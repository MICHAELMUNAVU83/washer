defmodule Washer.Workers.Worker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workers" do
    field :name, :string
    field :email, :string
    field :phone_number, :string
    belongs_to :branch, Washer.Branches.Branch
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(worker, attrs) do
    worker
    |> cast(attrs, [:name, :email, :phone_number, :branch_id, :user_id])
    |> validate_required([:name, :email, :phone_number])
  end
end
