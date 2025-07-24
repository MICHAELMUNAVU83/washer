defmodule Washer.Workers do
  @moduledoc """
  The Workers context.
  """

  import Ecto.Query, warn: false
  alias Washer.Repo

  alias Washer.Workers.Worker

  @doc """
  Returns the list of workers.

  ## Examples

      iex> list_workers()
      [%Worker{}, ...]

  """
  def list_workers do
    Repo.all(Worker)
    |> Repo.preload(:branch)
  end

  def list_workers_by_branch_for_select(branch_id) do
    from(w in Worker, where: w.branch_id == ^branch_id, select: {w.name, w.id})
    |> Repo.all()
  end

  @doc """
  Gets a single worker.

  Raises `Ecto.NoResultsError` if the Worker does not exist.

  ## Examples

      iex> get_worker!(123)
      %Worker{}

      iex> get_worker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_worker!(id), do: Repo.get!(Worker, id) |> Repo.preload(:branch)

  def services_for_worker(worker_id) do
    from(s in Washer.Services.Service,
      where: s.worker_id == ^worker_id,
      preload: [:car, :branch, :user]
    )
    |> Repo.all()
  end

  @doc """
  Creates a worker.

  ## Examples

      iex> create_worker(%{field: value})
      {:ok, %Worker{}}

      iex> create_worker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_worker(attrs \\ %{}) do
    %Worker{}
    |> Worker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a worker.

  ## Examples

      iex> update_worker(worker, %{field: new_value})
      {:ok, %Worker{}}

      iex> update_worker(worker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_worker(%Worker{} = worker, attrs) do
    worker
    |> Worker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a worker.

  ## Examples

      iex> delete_worker(worker)
      {:ok, %Worker{}}

      iex> delete_worker(worker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_worker(%Worker{} = worker) do
    Repo.delete(worker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking worker changes.

  ## Examples

      iex> change_worker(worker)
      %Ecto.Changeset{data: %Worker{}}

  """
  def change_worker(%Worker{} = worker, attrs \\ %{}) do
    Worker.changeset(worker, attrs)
  end
end
