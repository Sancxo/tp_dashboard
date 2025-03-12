defmodule TpDashboardWeb.Router do
  use TpDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TpDashboardWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TpDashboardWeb do
    pipe_through :browser

    get "/", PageController, :home

    # DashboardLive
    live "/dashboard/:user_id", DashboardLive.Index
  end

  scope "/admin", TpDashboardWeb do
    pipe_through :browser

    # UserLive
    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit

    # InvestmentLive
    live "/investments", InvestmentLive.Index, :index
    live "/investments/new", InvestmentLive.Index, :new
    live "/investments/:id/edit", InvestmentLive.Index, :edit

    live "/investments/:id", InvestmentLive.Show, :show
    live "/investments/:id/show/edit", InvestmentLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TpDashboardWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tp_dashboard, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TpDashboardWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
