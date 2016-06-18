defmodule Cataloger.SectionController do
  use Cataloger.Web, :controller

  alias Cataloger.Section

  plug :scrub_params, "section" when action in [:create, :update]

  def index(conn, _params) do
    sections = Repo.all(Section)
    render(conn, "index.html", sections: sections)
  end

  def new(conn, params) do
    changeset = Section.changeset(%Section{}, params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"section" => section_params}) do
    changeset = Section.changeset(%Section{}, section_params)

    case Repo.insert(changeset) do
      {:ok, _section} ->
        conn
        |> put_flash(:info, "Section created successfully.")
        |> redirect(to: section_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)
    render(conn, "show.html", section: section)
  end

  def edit(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)
    changeset = Section.changeset(section)
    render(conn, "edit.html", section: section, changeset: changeset)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Repo.get!(Section, id)
    changeset = Section.changeset(section, section_params)

    case Repo.update(changeset) do
      {:ok, section} ->
        conn
        |> put_flash(:info, "Section updated successfully.")
        |> redirect(to: section_path(conn, :show, section))
      {:error, changeset} ->
        render(conn, "edit.html", section: section, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(section)

    conn
    |> put_flash(:info, "Section deleted successfully.")
    |> redirect(to: section_path(conn, :index))
  end
end
