defmodule Washer.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :date, :date
    field :time, :time
    field :description, :string
    field :types, :string
    field :total_amount, :string
    field :worker_id, :id
    field :user_id, :id
    field :car_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:types, :total_amount, :date, :time, :description])
    |> validate_required([:types, :total_amount, :date, :time, :description])
  end
end
