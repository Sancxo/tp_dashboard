defmodule TpDashboard.Contracts.Investment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:label, :status, :amount, :transaction_date, :user_id],
    sortable: [:label, :status, :amount, :transaction_date],
  }

  schema "investments" do
    field :label, :string
    field :status, Ecto.Enum, values: [:processed, :rejected, :pending], default: :pending
    field :amount, :decimal
    field :transaction_date, :utc_datetime

    belongs_to :user, TpDashboard.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(investment, attrs) do
    investment
    |> cast(attrs, [:label, :amount, :transaction_date, :status])
    |> put_change(:transaction_date, DateTime.utc_now(:second))
    |> validate_required([:label, :amount, :transaction_date, :status])
  end
end
