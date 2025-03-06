defmodule TpDashboard.Repo.Migrations.CreateInvestments do
  use Ecto.Migration

  def change do
    create table(:investments) do
      add :label, :string
      add :amount, :decimal
      add :transaction_date, :utc_datetime
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:investments, [:user_id])
  end
end
