defmodule TpDashboardWeb.InvestmentLive.Show do
  use TpDashboardWeb, :live_view

  alias TpDashboard.Contracts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:investment, Contracts.get_investment!(id))}
  end

  defp page_title(:show), do: "Show Investment"
  defp page_title(:edit), do: "Edit Investment"
end
