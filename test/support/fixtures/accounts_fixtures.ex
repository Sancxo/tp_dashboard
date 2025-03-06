defmodule TpDashboard.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TpDashboard.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        name: "some name"
      })
      |> TpDashboard.Accounts.create_user()

    user
  end
end
