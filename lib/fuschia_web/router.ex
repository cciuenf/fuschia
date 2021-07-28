defmodule FuschiaWeb.Router do
  use FuschiaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug FuschiaWeb.LocalePlug
    plug ProperCase.Plug.SnakeCaseParams
  end

  scope "/api", FuschiaWeb do
    pipe_through :api
  end
end
