defmodule Cataloger.Router do
  use Cataloger.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cataloger do
    pipe_through :browser

    get "/", CatalogController, :index
    resources "/catalogs", CatalogController
    get "/catalogs/export/:id", CatalogController, :export
    resources "/sections", SectionController
    get "/preferences", PreferenceController, :index
    get "/preferences/edit", PreferenceController, :edit
    post "/preferences", PreferenceController, :update
    resources "/items", ItemController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Cataloger do
  #   pipe_through :api
  # end
end
