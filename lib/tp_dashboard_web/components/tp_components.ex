defmodule TpDashboardWeb.TpComponents do
  @moduledoc """
  A modulae containing customized components for this project.
  Components are based on Phoenix and SaladUI components.
  """

  use Phoenix.Component
  use Gettext, backend: TpDashboardWeb.Gettext

  import TpDashboardWeb.CoreComponents
  import SaladUI.Pagination

  alias SaladUI.Table

  attr :class, :string, default: nil
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def tp_header(assigns) do
    ~H"""
    <.header class={"text-center [&_h1]:text-green-500 [&_h1]:font-bold [&_h1]:text-4xl #{@class}"}>
      {render_slot(@inner_block)}

      <:subtitle>{render_slot(@subtitle)}</:subtitle>

      <:actions>{render_slot(@actions)}</:actions>
    </.header>
    """
  end

  # Table component

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_table(assigns) do
    ~H"""
    <Table.table class={@class} {@rest}>
      {render_slot(@inner_block)}
    </Table.table>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_table_header(assigns) do
    ~H"""
    <Table.table_header class={@class} {@rest}>
      {render_slot(@inner_block)}
    </Table.table_header>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_table_row(assigns) do
    ~H"""
    <Table.table_row class={@class} {@rest}>
      {render_slot(@inner_block)}
    </Table.table_row>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_table_head(assigns) do
    ~H"""
    <Table.table_head class={@class} {@rest}>
      {render_slot(@inner_block)}
    </Table.table_head>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_table_body(assigns) do
    ~H"""
    <Table.table_body class={@class} {@rest}>
      {render_slot(@inner_block)}
    </Table.table_body>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_table_cell(assigns) do
    ~H"""
    <Table.table_cell class={@class} {@rest}>
      {render_slot(@inner_block)}
    </Table.table_cell>
    """
  end

  # Pagination component
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_pagination(assigns) do
    ~H"""
    <.pagination class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.pagination>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_pagination_content(assigns) do
    ~H"""
    <.pagination_content class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.pagination_content>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tp_pagination_item(assigns) do
    ~H"""
    <.pagination_item class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.pagination_item>
    """
  end

  attr :"is-active", :boolean, default: false
  attr :size, :string, default: "icon"
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href patch navigate)
  slot :inner_block, required: true

  def tp_pagination_link(assigns) do
    assigns = assign(assigns, is_active: assigns[:"is-active"] in [true, "true"])

    ~H"""
    <.pagination_link is-active={@is_active} size={@size} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.pagination_link>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href patch navigate)

  def tp_pagination_next(assigns) do
    ~H"""
    <.pagination_next class={@class} {@rest} />
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href patch navigate)

  def tp_pagination_previous(assigns) do
    ~H"""
    <.pagination_previous class={@class} {@rest} />
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global

  def tp_pagination_ellipsis(assigns) do
    ~H"""
    <.pagination_ellipsis class={@class} {@rest} />
    """
  end
end
