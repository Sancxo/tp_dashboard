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

  @impl true
  def mount(%{"user_id" => user_id}, _, socket) do
    user = Accounts.get_user!(user_id)
    total_amount = Contracts.count_total_user_investments(user_id)

    user_form = user |> Accounts.change_user() |> to_form()
    investment_form = %Investment{} |> Contracts.change_investment() |> to_form()
    investment = %Investment{}

    socket =
      socket
      |> assign(user: user, user_form: user_form, investment_form: investment_form, investment: investment, total_amount: total_amount)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"page" => current_page} = new_params, _url, socket) do
    {:ok, {investments, meta}} = Contracts.list_user_investments(new_params)

    {first_page_link_range, last_page_link_range} = Flop.Phoenix.page_link_range(3, String.to_integer(current_page), meta.total_pages)
    socket =
      socket
      |> assign(meta: meta, page_link_range: first_page_link_range..last_page_link_range)
      |> stream(:investments, investments, reset: true)

      {:noreply, socket}
  end

  def handle_params(%{"user_id" => current_user_id}, _uri, socket) do
    flop_params = %{
      order_by: ["transaction_date"],
      order_directions: ["desc"],
      page: 1,
      page_size: 5,
      filters: [%{field: :user_id, op: :==, value: current_user_id}]
    }

    {:ok, {investments, meta}} = Contracts.list_user_investments(flop_params)
    meta |> IO.inspect(label: "meta")

    {first_page_link_range, last_page_link_range} = Flop.Phoenix.page_link_range(3, flop_params.page, meta.total_pages)

    socket =
      socket
      |> assign(meta: meta, page_link_range: first_page_link_range..last_page_link_range)
      |> stream(:investments, investments, reset: true)

    {:noreply, socket}
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

  @impl true
  def handle_event("investment-validate", %{"investment" => investment_params}, %{assigns: %{investment: investment}} = socket) do
    investment_form = investment |> Contracts.change_investment(investment_params) |> to_form(action: :validate)

    {:noreply, socket |> assign(investment_form: investment_form)}
  end

  def handle_event("investment-submit", %{"investment" => investment_params}, %{assigns: %{user: user}} = socket) do
    new_socket =
      user
      |> Contracts.create_user_investment(investment_params)
      |> case do
        {:ok, new_investment} ->
          socket
          |> stream_insert(:investments, new_investment)
          |> put_flash(:info, gettext("Your investment has been added successfully"))

        {:error, _} ->
          Logger.error("An error occurred when adding investment for user with id #{user.id}")

          put_flash(socket, :error, gettext("An error occurred when adding an investment"))
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

  attr :investment_form, Phoenix.HTML.Form, required: true, doc: "The form to validate the Investment data"

  def add_investment_modal(assigns)

end
