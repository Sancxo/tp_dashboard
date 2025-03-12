defmodule TpDashboardWeb.TpComponents do
  @moduledoc """
  A module containing customized components.
  """

  use Phoenix.Component
  use Gettext, backend: TpDashboardWeb.Gettext

  import  TpDashboardWeb.CoreComponents

  alias Phoenix.LiveView.JS
  alias SaladUI.Card

  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def tp_header(assigns) do
    ~H"""
    <.header class={@class}>
      {render_slot(@inner_block)}

      <:subtitle>{render_slot(@subtitle)}</:subtitle>
      <:actions>{render_slot(@actions)}</:actions>
    </.header>
    """
  end

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def tp_button(assigns) do
    ~H"""
    <.button
      type={@type}
      class={"bg-red-500 #{@class}"}
      {@rest}
      >
        {render_slot(@inner_block)}
    </.button>
    """
  end

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any
  attr :field, :any
  attr :placeholder, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  def tp_input(assigns) do
    ~H"""
    <.input
        type={@type}
        label={@label}
        field={@field}
        value={@value}
        placeholder="PLACEHOLDER-TP"
      />
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def tp_card(assigns) do
    ~H"""
    <Card.card class={"#{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </Card.card>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def tp_card_header(assigns) do
    ~H"""
    <Card.card_header class={"#{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </Card.card_header>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def tp_card_title(assigns) do
    ~H"""
    <Card.card_title class={"#{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </Card.card_title>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def tp_card_description(assigns) do
    ~H"""
    <Card.card_description class={"#{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </Card.card_description>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block, required: true
  attr :rest, :global

  def tp_card_content(assigns) do
    ~H"""
    <Card.card_content class={"#{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </Card.card_content>
    """
  end

  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def tp_modal(assigns) do
    ~H"""
    <.modal id={@id} show={@show} on_cancel={@on_cancel}>
      {render_slot(@inner_block)}
    </.modal>
    """
  end

  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def tp_simple_form(assigns) do
    ~H"""
    <.simple_form for={@for} as={@as} {@rest}>
      {render_slot(@inner_block)}
      <:actions>{render_slot(@actions)}</:actions>
    </.simple_form>
    """
  end


end
