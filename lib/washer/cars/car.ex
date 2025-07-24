defmodule Washer.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :name, :string
    field :number_plate, :string
    field :email, :string
    field :phone_number, :string
    belongs_to :branch, Washer.Branches.Branch, foreign_key: :registered_at
    field :registered_by, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:number_plate, :name, :email, :phone_number, :registered_at, :registered_by])
    |> validate_required([:number_plate, :name, :email, :phone_number])
  end
end
