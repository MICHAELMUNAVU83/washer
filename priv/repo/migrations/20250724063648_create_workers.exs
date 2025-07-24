defmodule Washer.Repo.Migrations.CreateWorkers do
  use Ecto.Migration

  def change do
    create table(:workers) do
      add :name, :string
      add :email, :string
      add :phone_number, :string
      add :branch_id, references(:branches, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:workers, [:branch_id])
    create index(:workers, [:user_id])
  end
end
