defmodule TpDashboardWeb.InvestmentLive.FormComponent do
  use TpDashboardWeb, :live_component

  alias TpDashboard.Contracts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage investment records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="investment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:label]} type="text" label="Label" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:transaction_date]} type="datetime-local" label="Transaction date" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(TpDashboard.Contracts.Investment, :status)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Investment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{investment: investment} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Contracts.change_investment(investment))
     end)}
  end

  @impl true
  def handle_event("validate", %{"investment" => investment_params}, socket) do
    changeset = Contracts.change_investment(socket.assigns.investment, investment_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"investment" => investment_params}, socket) do
    save_investment(socket, socket.assigns.action, investment_params)
  end

  defp save_investment(socket, :edit, investment_params) do
    case Contracts.update_investment(socket.assigns.investment, investment_params) do
      {:ok, investment} ->
        notify_parent({:saved, investment})

        {:noreply,
         socket
         |> put_flash(:info, "Investment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_investment(socket, :new, investment_params) do
    case Contracts.create_investment(investment_params) do
      {:ok, investment} ->
        notify_parent({:saved, investment})

        {:noreply,
         socket
         |> put_flash(:info, "Investment created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
