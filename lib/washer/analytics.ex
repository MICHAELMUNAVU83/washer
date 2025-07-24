defmodule Washer.Analytics do
  @moduledoc """
  Analytics context for dashboard queries and reporting.
  """

  import Ecto.Query, warn: false
  alias Washer.Repo
  alias Washer.{Services.Service, Branches.Branch, Workers.Worker, Cars.Car}

  @doc """
  Get overview statistics for the dashboard
  """
  def get_overview_stats({start_date, end_date}) do
    # Current period stats
    current_stats = get_period_stats(start_date, end_date)

    # Previous period for comparison
    period_length = Date.diff(end_date, start_date)
    prev_end_date = Date.add(start_date, -1)
    prev_start_date = Date.add(prev_end_date, -period_length)
    previous_stats = get_period_stats(prev_start_date, prev_end_date)

    # Calculate percentage changes
    revenue_change =
      calculate_percentage_change(current_stats.total_revenue, previous_stats.total_revenue)

    services_change =
      calculate_percentage_change(current_stats.total_services, previous_stats.total_services)

    %{
      total_revenue: format_currency(current_stats.total_revenue),
      total_services: current_stats.total_services,
      active_customers: current_stats.active_customers,
      avg_service_value: format_currency(current_stats.avg_service_value),
      revenue_change: revenue_change,
      services_change: services_change
    }
  end

  @doc """
  Get branch performance data
  """
  def get_branch_performance({start_date, end_date}) do
    query =
      from b in Branch,
        left_join: s in Service,
        on: s.branch_id == b.id and s.date >= ^start_date and s.date <= ^end_date,
        left_join: w in Worker,
        on: w.branch_id == b.id,
        left_join: c in Car,
        on: c.registered_at == b.id,
        group_by: [b.id, b.name, b.location],
        select: %{
          id: b.id,
          name: b.name,
          location: b.location,
          revenue: coalesce(sum(fragment("CAST(? AS DECIMAL)", s.total_amount)), 0),
          services_count: count(s.id),
          workers_count: count(fragment("DISTINCT ?", w.id)),
          cars_count: count(fragment("DISTINCT ?", c.id))
        },
        order_by: [desc: sum(fragment("CAST(? AS DECIMAL)", s.total_amount))]

    Repo.all(query)
    |> Enum.map(fn branch ->
      Map.put(branch, :revenue, format_currency(branch.revenue))
    end)
  end

  @doc """
  Get top performing workers
  """
  def get_top_workers({start_date, end_date}, opts \\ []) do
    limit = Keyword.get(opts, :limit, 10)

    query =
      from w in Worker,
        join: b in Branch,
        on: w.branch_id == b.id,
        left_join: s in Service,
        on: s.worker_id == w.id and s.date >= ^start_date and s.date <= ^end_date,
        group_by: [w.id, w.name, b.name],
        select: %{
          id: w.id,
          name: w.name,
          branch_name: b.name,
          revenue: coalesce(sum(fragment("CAST(? AS DECIMAL)", s.total_amount)), 0),
          services_count: count(s.id),
          avg_service_value: coalesce(avg(fragment("CAST(? AS DECIMAL)", s.total_amount)), 0)
        },
        order_by: [desc: sum(fragment("CAST(? AS DECIMAL)", s.total_amount))],
        limit: ^limit

    Repo.all(query)
    |> Enum.map(fn worker ->
      worker
      |> Map.put(:revenue, format_currency(worker.revenue))
      |> Map.put(:avg_service_value, format_currency(worker.avg_service_value))
    end)
  end

  @doc """
  Get revenue chart data for time series
  """
  def get_revenue_chart_data({start_date, end_date}) do
    query =
      from s in Service,
        where: s.date >= ^start_date and s.date <= ^end_date,
        group_by: s.date,
        select: %{
          date: s.date,
          revenue: sum(fragment("CAST(? AS DECIMAL)", s.total_amount))
        },
        order_by: s.date

    Repo.all(query)
    |> Enum.map(fn day ->
      %{
        date: Calendar.strftime(day.date, "%m/%d"),
        revenue: Decimal.to_float(day.revenue || Decimal.new("0"))
      }
    end)
  end

  @doc """
  Get services distribution data for pie chart
  """
  def get_services_chart_data({start_date, end_date}) do
    # Get all services in date range
    services =
      from s in Service,
        where: s.date >= ^start_date and s.date <= ^end_date,
        select: s.types

    Repo.all(services)
    |> Enum.flat_map(fn types_string ->
      String.split(types_string || "", ",", trim: true)
      |> Enum.map(&String.trim/1)
    end)
    |> Enum.frequencies()
    |> Enum.map(fn {service_type, count} ->
      %{
        service_type: service_type,
        count: count
      }
    end)
    |> Enum.sort_by(& &1.count, :desc)
  end

  @doc """
  Get payment status distribution
  """
  def get_payment_status_data({start_date, end_date}) do
    query =
      from s in Service,
        where: s.date >= ^start_date and s.date <= ^end_date,
        group_by: s.payment_completed,
        select: %{
          status: s.payment_completed,
          count: count(s.id),
          total_amount: sum(fragment("CAST(? AS DECIMAL)", s.total_amount))
        }

    results = Repo.all(query)

    paid_data =
      Enum.find(results, %{count: 0, total_amount: Decimal.new("0")}, &(&1.status == true))

    pending_data =
      Enum.find(results, %{count: 0, total_amount: Decimal.new("0")}, &(&1.status == false))

    [
      %{
        status: "Paid",
        count: paid_data.count,
        amount: Decimal.to_float(paid_data.total_amount || Decimal.new("0"))
      },
      %{
        status: "Pending",
        count: pending_data.count,
        amount: Decimal.to_float(pending_data.total_amount || Decimal.new("0"))
      }
    ]
  end

  # Private helper functions

  defp get_period_stats(start_date, end_date) do
    query =
      from s in Service,
        where: s.date >= ^start_date and s.date <= ^end_date,
        select: %{
          total_revenue: coalesce(sum(fragment("CAST(? AS DECIMAL)", s.total_amount)), 0),
          total_services: count(s.id),
          active_customers: count(fragment("DISTINCT ?", s.car_id)),
          avg_service_value: coalesce(avg(fragment("CAST(? AS DECIMAL)", s.total_amount)), 0)
        }

    result = Repo.one(query)

    %{
      total_revenue: Decimal.to_float(result.total_revenue || Decimal.new("0")),
      total_services: result.total_services || 0,
      active_customers: result.active_customers || 0,
      avg_service_value: Decimal.to_float(result.avg_service_value || Decimal.new("0"))
    }
  end

  defp calculate_percentage_change(current, previous) when previous == 0 and current > 0, do: 100
  defp calculate_percentage_change(current, previous) when previous == 0, do: 0

  defp calculate_percentage_change(current, previous) do
    ((current - previous) / previous * 100) |> Float.round(1)
  end

  defp format_currency(amount) when is_number(amount) do
    :erlang.float_to_binary(amount, decimals: 2)
  end

  defp format_currency(amount) do
    "0.00"
  end
end
