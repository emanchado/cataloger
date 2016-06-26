defmodule Cataloger.CatalogController do
  use Cataloger.Web, :controller

  alias Cataloger.Catalog
  alias Cataloger.Preference
  alias Cataloger.Endpoint

  plug :scrub_params, "catalog" when action in [:create, :update]

  def index(conn, _params) do
    catalogs = Repo.all(Catalog)
    render(conn, "index.html", catalogs: catalogs)
  end

  def new(conn, _params) do
    changeset = Catalog.changeset(%Catalog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"catalog" => catalog_params}) do
    changeset = Catalog.changeset(%Catalog{}, catalog_params)

    case Repo.insert(changeset) do
      {:ok, _catalog} ->
        conn
        |> put_flash(:info, "Catalog created successfully.")
        |> redirect(to: catalog_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    catalog = Catalog |> Repo.get!(id) |> Repo.preload([:sections])
    render(conn, "show.html", catalog: catalog, page_title: catalog.name)
  end

  def edit(conn, %{"id" => id}) do
    catalog = Repo.get!(Catalog, id)
    changeset = Catalog.changeset(catalog)
    render(conn, "edit.html", catalog: catalog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "catalog" => catalog_params}) do
    catalog = Repo.get!(Catalog, id)
    changeset = Catalog.changeset(catalog, catalog_params)

    case Repo.update(changeset) do
      {:ok, catalog} ->
        conn
        |> put_flash(:info, "Catalog updated successfully.")
        |> redirect(to: catalog_path(conn, :show, catalog))
      {:error, changeset} ->
        render(conn, "edit.html", catalog: catalog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    catalog = Repo.get!(Catalog, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(catalog)

    conn
    |> put_flash(:info, "Catalog deleted successfully.")
    |> redirect(to: catalog_path(conn, :index))
  end

  def export(conn, %{"id" => id}) do
    catalog = Repo.get!(Catalog, id)
    base_export_dir = Application.get_env(:cataloger, :export_dir)
    catalog_export_dir = Path.join(base_export_dir, id)

    render(conn, "export.html",
           catalog: catalog,
           exported_dir: catalog_export_dir)
  end
end
