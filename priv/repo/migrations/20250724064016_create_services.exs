defmodule Washer.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :number_plate, :string
      add :name, :string
      add :email, :string
      add :phone_number, :string
      add :registered_at, references(:branches, on_delete: :nothing)
      add :registered_by, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:cars, [:registered_at])
    create index(:cars, [:registered_by])
  end
end
