defmodule Washer.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :date, :date
    field :time, :time
    field :description, :string
    field :types, :string
    field :total_amount, :integer
    belongs_to :branch, Washer.Branches.Branch, foreign_key: :branch_id
    belongs_to :user, Washer.Accounts.User
    belongs_to :worker, Washer.Workers.Worker, foreign_key: :worker_id
    belongs_to :car, Washer.Cars.Car
    field :payment_completed, :boolean, default: false
    field :payment_method, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [
      :types,
      :total_amount,
      :date,
      :time,
      :description,
      :branch_id,
      :user_id,
      :worker_id,
      :car_id,
      :payment_completed,
      :payment_method
    ])
    |> validate_required([
      :types,
      :total_amount,
      :date,
      :time,
      :description,
      :branch_id,
      :user_id,
      :car_id
    ])
  end
end
