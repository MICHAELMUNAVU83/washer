defmodule Washer.Services do
  @moduledoc """
  The Services context.
  """

  import Ecto.Query, warn: false
  alias Washer.Repo

  alias Washer.Services.Service

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services do
    Repo.all(Service)
  end

  def list_paid_services_by_branch_total_amount(branch_id) do
    from(s in Service,
      where: s.branch_id == ^branch_id and s.payment_completed == true,
      select: sum(s.total_amount)
    )
    |> Repo.one()
  end

  def list_paid_services_by_worker_total_amount(worker_id) do
    from(s in Service,
      where: s.worker_id == ^worker_id and s.payment_completed == true,
      select: sum(s.total_amount)
    )
    |> Repo.one()
  end

  def get_average_service_value_by_worker(worker_id) do
    from(s in Service,
      where: s.worker_id == ^worker_id and s.payment_completed == true,
      select: avg(s.total_amount)
    )
    |> Repo.one()
    |> case do
      nil -> 0
      avg -> avg |> Decimal.round(2)
    end
  end

  def list_paid_services_by_car_total_amount(car_id) do
    from(s in Service,
      where: s.car_id == ^car_id and s.payment_completed == true,
      select: sum(s.total_amount)
    )
    |> Repo.one()
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(123)
      %Service{}

      iex> get_service!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(id), do: Repo.get!(Service, id)

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs \\ %{}) do
    %Service{}
    |> Service.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Service{} = service, attrs) do
    service
    |> Service.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a service.

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{data: %Service{}}

  """
  def change_service(%Service{} = service, attrs \\ %{}) do
    Service.changeset(service, attrs)
  end
end
