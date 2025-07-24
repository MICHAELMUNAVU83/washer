defmodule Washer.Repo.Migrations.AddPaymentStats do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :date, :date
      add :time, :time
      add :description, :string
      add :types, :string
      add :total_amount, :integer
      add :branch_id, references(:branches, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :car_id, references(:cars, on_delete: :nothing)

      add :payment_completed, :boolean, default: false, null: false
      add :payment_method, :string

      timestamps(type: :utc_datetime)
    end
  end
end
