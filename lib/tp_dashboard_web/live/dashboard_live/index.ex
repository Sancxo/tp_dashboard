defmodule TpDashboardWeb.DashboardLive.Index do
  use TpDashboardWeb, :live_view
  import SaladUI.{Card, Separator}
  require Logger
  alias TpDashboard.Accounts
  alias TpDashboard.Accounts.User

  @impl true
  def mount(%{"user_id" => user_id}, _, socket) do
    user = Accounts.get_user!(user_id)

    user_form = user |> Accounts.change_user() |> to_form()

    {:ok, socket |> assign(user: user, user_form: user_form)}
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
end
