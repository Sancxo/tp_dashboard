defmodule TpDashboardWeb.InvestmentLive.Index do
  use TpDashboardWeb, :live_view

  alias TpDashboard.Contracts
  alias TpDashboard.Contracts.Investment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :investments, Contracts.list_investments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Investment")
    |> assign(:investment, Contracts.get_investment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Investment")
    |> assign(:investment, %Investment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Investments")
    |> assign(:investment, nil)
  end

  @impl true
  def handle_info({TpDashboardWeb.InvestmentLive.FormComponent, {:saved, investment}}, socket) do
    {:noreply, stream_insert(socket, :investments, investment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    investment = Contracts.get_investment!(id)
    {:ok, _} = Contracts.delete_investment(investment)

    {:noreply, stream_delete(socket, :investments, investment)}
  end
end
