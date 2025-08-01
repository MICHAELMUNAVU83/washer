defmodule Washer.Branches do
  @moduledoc """
  The Branches context.
  """

  import Ecto.Query, warn: false
  alias Washer.Repo

  alias Washer.Branches.Branch

  @doc """
  Returns the list of branches.

  ## Examples

      iex> list_branches()
      [%Branch{}, ...]

  """
  def list_branches do
    Repo.all(Branch)
  end

  def list_branches_for_select do
    from(b in Branch, order_by: [asc: b.name])
    |> Repo.all()
    |> Enum.map(fn branch -> {branch.name, branch.id} end)
  end

  def list_branch_workers(branch_id) do
    from(w in Washer.Workers.Worker,
      where: w.branch_id == ^branch_id,
      order_by: [asc: w.name]
    )
    |> Repo.all()
  end

  def list_branch_cars(branch_id) do
    from(c in Washer.Cars.Car,
      where: c.registered_at == ^branch_id,
      order_by: [asc: c.name]
    )
    |> Repo.all()
  end

  def workers_count(branch_id) do
    from(w in Washer.Workers.Worker, where: w.branch_id == ^branch_id)
    |> Repo.aggregate(:count, :id)
  end

  def cars_count(branch_id) do
    from(c in Washer.Cars.Car, where: c.registered_at == ^branch_id)
    |> Repo.aggregate(:count, :id)
  end

  

  @doc """
  Gets a single branch.

  Raises `Ecto.NoResultsError` if the Branch does not exist.

  ## Examples

      iex> get_branch!(123)
      %Branch{}

      iex> get_branch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_branch!(id), do: Repo.get!(Branch, id)

  @doc """
  Creates a branch.

  ## Examples

      iex> create_branch(%{field: value})
      {:ok, %Branch{}}

      iex> create_branch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a branch.

  ## Examples

      iex> update_branch(branch, %{field: new_value})
      {:ok, %Branch{}}

      iex> update_branch(branch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branch(%Branch{} = branch, attrs) do
    branch
    |> Branch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a branch.

  ## Examples

      iex> delete_branch(branch)
      {:ok, %Branch{}}

      iex> delete_branch(branch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branch(%Branch{} = branch) do
    Repo.delete(branch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branch changes.

  ## Examples

      iex> change_branch(branch)
      %Ecto.Changeset{data: %Branch{}}

  """
  def change_branch(%Branch{} = branch, attrs \\ %{}) do
    Branch.changeset(branch, attrs)
  end
end
