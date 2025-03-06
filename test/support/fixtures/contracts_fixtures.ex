defmodule TpDashboard.ContractsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TpDashboard.Contracts` context.
  """

  @doc """
  Generate a investment.
  """
  def investment_fixture(attrs \\ %{}) do
    {:ok, investment} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        label: "some label",
        status: :processed,
        transaction_date: ~U[2025-03-05 09:58:00Z]
      })
      |> TpDashboard.Contracts.create_investment()

    investment
  end
end
