defmodule TpDashboardWeb.DashboardLive.InvestmentFormComponent do
  use TpDashboardWeb, :live_component

  alias TpDashboard.Contracts

  require Logger

  @impl true
  def update(%{investment: investment} = assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_new(:investment_form, fn ->
          investment |> Contracts.change_investment() |> to_form()
      end)}
  end

  @impl true
  def handle_event("investment-validate", %{"investment" => investment_params}, %{assigns: %{investment: investment}} = socket) do
    investment_form = investment |> Contracts.change_investment(investment_params |> IO.inspect(label: "investment params")) |> to_form(action: :validate)

    {:noreply, socket |> assign(investment_form: investment_form)}
  end

  def handle_event("investment-submit", %{"investment" => investment_params}, %{assigns: %{live_action: live_action}} = socket) do
    new_socket = save_investment(socket, live_action, investment_params)

    {:noreply, new_socket}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        :let={f}
        for={@investment_form}
        phx-change="investment-validate"
        phx-submit={JS.push("investment-submit") |> JS.patch("/dashboard/#{@user.id}")}
        phx-target={@myself}
      >
        <.input
          type="text"
          field={f[:label]}
          label={gettext("Label")}
          placeholder={gettext("Type your label here ...")}
          value={f[:label].value}
        />

        <.input
          type="number"
          field={f[:amount]}
          label={gettext("Amount")}
          value={f[:amount].value}
          placeholder={gettext("Type the amount here ...")}
          disabled={@live_action == :update_investment}
        />

        <.tp_button type="submit">{gettext("Add")}</.tp_button>
      </.form>
    </div>
    """
  end

  defp save_investment(%{assigns: %{user: user}} = socket, :create_investment, investment_params) do
    user
    |> Contracts.create_user_investment(investment_params)
    |> case do
      {:ok, _new_investment} ->
        socket
        |> put_flash(:info, gettext("Your investment has been added successfully"))
        |> push_patch(to: "/dashboard/#{user.id}")

      {:error, _} ->
        Logger.error("An error occurred when adding investment for user with id #{user.id}")

        put_flash(socket, :error, gettext("An error occurred when adding an investment"))
    end
  end

  defp save_investment(%{assigns: %{investment: investment, user: user}} = socket, :update_investment, investment_params) do
    investment
    |> Contracts.update_investment(investment_params)
    |> case do
      {:ok, _new_investment} ->
        socket
        |> put_flash(:info, gettext("Your investment has been updated successfully"))
        |> push_patch(to: "/dashboard/#{user.id}")

      {:error, _} ->
        Logger.error("An error occurred when updating an investment for user with id #{user.id}")

        put_flash(socket, :error, gettext("An error occurred when updating an investment"))
    end
  end
end
