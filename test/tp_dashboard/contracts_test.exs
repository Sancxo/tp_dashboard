defmodule TpDashboard.ContractsTest do
  use TpDashboard.DataCase

  alias TpDashboard.Contracts

  describe "investments" do
    alias TpDashboard.Contracts.Investment

    import TpDashboard.ContractsFixtures

    @invalid_attrs %{label: nil, status: nil, amount: nil, transaction_date: nil}

    test "list_investments/0 returns all investments" do
      investment = investment_fixture()
      assert Contracts.list_investments() == [investment]
    end

    test "get_investment!/1 returns the investment with given id" do
      investment = investment_fixture()
      assert Contracts.get_investment!(investment.id) == investment
    end

    test "create_investment/1 with valid data creates a investment" do
      valid_attrs = %{label: "some label", status: :processed, amount: "120.5", transaction_date: ~U[2025-03-05 09:58:00Z]}

      assert {:ok, %Investment{} = investment} = Contracts.create_investment(valid_attrs)
      assert investment.label == "some label"
      assert investment.status == :processed
      assert investment.amount == Decimal.new("120.5")
      assert investment.transaction_date == ~U[2025-03-05 09:58:00Z]
    end

    test "create_investment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_investment(@invalid_attrs)
    end

    test "update_investment/2 with valid data updates the investment" do
      investment = investment_fixture()
      update_attrs = %{label: "some updated label", status: :rejected, amount: "456.7", transaction_date: ~U[2025-03-06 09:58:00Z]}

      assert {:ok, %Investment{} = investment} = Contracts.update_investment(investment, update_attrs)
      assert investment.label == "some updated label"
      assert investment.status == :rejected
      assert investment.amount == Decimal.new("456.7")
      assert investment.transaction_date == ~U[2025-03-06 09:58:00Z]
    end

    test "update_investment/2 with invalid data returns error changeset" do
      investment = investment_fixture()
      assert {:error, %Ecto.Changeset{}} = Contracts.update_investment(investment, @invalid_attrs)
      assert investment == Contracts.get_investment!(investment.id)
    end

    test "delete_investment/1 deletes the investment" do
      investment = investment_fixture()
      assert {:ok, %Investment{}} = Contracts.delete_investment(investment)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_investment!(investment.id) end
    end

    test "change_investment/1 returns a investment changeset" do
      investment = investment_fixture()
      assert %Ecto.Changeset{} = Contracts.change_investment(investment)
    end
  end
end
