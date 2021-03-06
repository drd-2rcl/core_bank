defmodule CoreBankApiWeb.Router do
  use CoreBankApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CoreBankApiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CoreBankApiWeb.Auth.Pipeline
  end

  scope "/api/v1", CoreBankApiWeb.Api.V1 do
    pipe_through [:api, :auth]

    post "/transfers", TransferController, :create
    post "/accounts/:id/withdraw", AccountController, :withdraw
    get "/accounts/:id/report", AccountController, :export
  end

  scope "/api/v1", CoreBankApiWeb.Api.V1 do
    pipe_through :api

    post "/users", UserController, :create
    post "/users/signin", UserController, :sign_in
  end

  scope "/", CoreBankApiWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CoreBankApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CoreBankApiWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
