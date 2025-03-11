defmodule TpDashboard.Contracts do
  @moduledoc """
  The Contracts context.
  """

  import Ecto.Query, warn: false
  alias TpDashboard.Accounts.User
  alias TpDashboard.Repo

  alias TpDashboard.Contracts.Investment

  @doc """
  Returns the list of investments.

  ## Examples

      iex> list_investments()
      [%Investment{}, ...]

  """
  def list_investments do
    Repo.all(Investment)
  end

  def list_user_investments(flop_params) do
    Flop.validate_and_run(
      Investment,
      flop_params,
      for: Investment,
      replace_invalid_params: true
    )
  end

  @doc """
  Returns the list of investments for a specific User.

  ## Examples

      iex> list_5_last_user_investments(123)
      [%Investment{user_id: 123}, ...]
  """
  @spec list_5_last_user_investments(integer() | String.t()) :: [User]
  def list_5_last_user_investments(user_id) do
    Investment
    |> where(user_id: ^user_id)
    |> limit(5)
    |> order_by(desc: :transaction_date)
    |> Repo.all()
  end

  @doc """
  Query to calculate the total amount of investments for a specific user

  ## Examples

      iex> count_total_user_investments(123)
      3600
  """
  def count_total_user_investments(user_id) do
    Investment
    |> where(user_id: ^user_id)
    |> select([u], sum(u.amount))
    |> Repo.one()
  end

  @doc """
  Gets a single investment.

  Raises `Ecto.NoResultsError` if the Investment does not exist.

  ## Examples

      iex> get_investment!(123)
      %Investment{}

      iex> get_investment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_investment!(id), do: Repo.get!(Investment, id)

  @doc """
  Creates a investment.

  ## Examples

      iex> create_investment(%{field: value})
      {:ok, %Investment{}}

      iex> create_investment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_investment(attrs \\ %{}) do
    %Investment{}
    |> Investment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a investment for a specific user.

  ## Examples

      iex> create_user_investment(%User{id: 123}, %{field: value})
      {:ok, %Investment{user_id: 123}}

      iex> create_user_investment%User{id: 123}, (%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_investment(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:investments)
    |> Investment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a investment.

  ## Examples

      iex> update_investment(investment, %{field: new_value})
      {:ok, %Investment{}}

      iex> update_investment(investment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_investment(%Investment{} = investment, attrs) do
    investment
    |> Investment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a investment.

  ## Examples

      iex> delete_investment(investment)
      {:ok, %Investment{}}

      iex> delete_investment(investment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_investment(%Investment{} = investment) do
    Repo.delete(investment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking investment changes.

  ## Examples

      iex> change_investment(investment)
      %Ecto.Changeset{data: %Investment{}}

  """
  def change_investment(%Investment{} = investment, attrs \\ %{}) do
    Investment.changeset(investment, attrs)
  end
end
