defmodule Washer.Repo.Migrations.AddWorkerId do
  use Ecto.Migration

  def change do
    alter table(:services) do
      add :worker_id, references(:workers, on_delete: :nothing)
    end

    create index(:services, [:worker_id])
  end
end
