defmodule TpDashboardWeb.DashboardLive.Index do
  use TpDashboardWeb, :live_view
  import SaladUI.Separator
  import SaladUI.Pagination
  require Logger

  alias TpDashboard.Accounts
  alias TpDashboard.Accounts.User

  alias TpDashboard.Contracts
  alias TpDashboard.Contracts.Investment

  alias SaladUI.Table
  alias TpDashboardWeb.DashboardLive.InvestmentFormComponent

  @impl true
  def mount(%{"user_id" => user_id}, _, socket) do
    user = Accounts.get_user!(user_id)
    total_amount = Contracts.count_total_user_investments(user_id)

    user_form = user |> Accounts.change_user() |> to_form()

    {:ok, socket
    |> assign(user: user, user_form: user_form, investment: nil, total_amount: total_amount)}

  end

  @impl true
def handle_params(url_params, _, %{assigns: %{live_action: live_action}} = socket) do
    {:noreply, apply_action(socket, live_action, url_params)}
  end


  @impl true
  def handle_event("user-validate", %{"user" => user_params}, %{assigns: %{user: user}} = socket) do
    user_form = user |> Accounts.change_user(user_params) |> to_form(action: :validate)

    {:noreply, socket |> assign(user_form: user_form)}
  end

  def handle_event("user-submit", %{"user" => user_params}, %{assigns: %{user: user}} = socket) do
    new_socket =
      user
      |> Accounts.update_user(user_params)
      |> case do
        {:ok, user} ->
          socket
          |> assign(user: user)
          |> put_flash(:info, gettext("Your settings have been updated successfully"))

        {:error, _} ->
          Logger.error("An error occurred when updating user with id #{user.id}")

          put_flash(socket, :error, gettext("An error occurred when updating your settings"))
      end

    {:noreply, new_socket}
  end

  embed_templates("dashboard_components/*")

  @doc """
  The modal to store the form used to update the User dashboard settings.
  """
  attr :user, User, required: true, doc: "The User which is meant to be updated"
  attr :user_form, Phoenix.HTML.Form, required: true, doc: "The form to validate the User data"

  def user_settings_modal(assigns)

  attr :live_action, :atom, doc: "Live action inheaderited from router"
  attr :user, :any, required: true, doc: "The User for which the investments are being displayed"
  attr :investment, Investment, default: nil, doc: "The form to validate the Investment data"


  def investment_form_modal(assigns) do
    ~H"""
    <.tp_modal :if={@live_action in [:create_investment, :update_investment]} id="investment-form-modal" show={true} on_cancel={JS.patch("/dashboard/#{@user.id}")}>
      <h3>Add  an investment</h3>

      <.live_component
        module={InvestmentFormComponent}
        investment={@investment}
        user={@user}
        live_action={@live_action}
        id={"investment-form"} />
    </.tp_modal>
    """
  end

  defp apply_action(socket, :create_investment, _params), do: assign(socket, investment: %Investment{})

  defp apply_action(socket, :update_investment, %{"investment_id" => investment_id}) do
    investment = Contracts.get_investment!(investment_id)

    assign(socket, investment: investment)
  end



  defp apply_action(socket, :index, %{"page" => current_page} = params) do
    {:ok, {investments, meta}} = Contracts.list_user_investments(params)

    {first_page_link_range, last_page_link_range} = Flop.Phoenix.page_link_range(3, String.to_integer(current_page), meta.total_pages)

    socket
    |> assign(meta: meta, page_link_range: first_page_link_range..last_page_link_range)
    |> stream(:investments_list, investments, reset: true)
  end

  defp apply_action(socket, :index, %{"user_id" => user_id}) do
    flop_params = %{
      order_by: ["transaction_date"],
      order_directions: [:desc],
      page: 1,
      page_size: 5,
      filters: [%{field: :user_id, op: :==, value: user_id}]
    }

    {:ok, {investments, meta}} = Contracts.list_user_investments(flop_params)

    {first_page_link_range, last_page_link_range} = Flop.Phoenix.page_link_range(3, flop_params.page, meta.total_pages)

    socket
    |> assign(meta: meta, page_link_range: first_page_link_range..last_page_link_range)
    |> stream(:investments_list, investments, reset: true)
  end

  defp apply_action(socket, _, _), do: socket
end
