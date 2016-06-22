defmodule Cataloger.PreferenceController do
  use Cataloger.Web, :controller

  alias Cataloger.Preference

  def index(conn, _params) do
    thumbnail_sizes = Preference.get_preference(:thumbnail_sizes)
    render(conn, "index.html", thumbnail_sizes: thumbnail_sizes)
  end

  def edit(conn, _params) do
    thumbnail_sizes = Preference.get_preference(:thumbnail_sizes)
    render(conn, "edit.html", thumbnail_sizes: thumbnail_sizes)
  end

  def update(conn, %{"thumbnail_sizes" => thumbnail_sizes}) do
    preference_from_db = Repo.get_by(Preference, %{name: "thumbnail_sizes"})
    preference = preference_from_db || %Preference{name: "thumbnail_sizes"}
    changeset = Preference.changeset(preference, %{"value" => thumbnail_sizes})

    case Repo.insert_or_update(changeset) do
      {:ok, preference} ->
        conn
        |> put_flash(:info, "Preference updated successfully.")
        |> redirect(to: preference_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", thumbnail_sizes: thumbnail_sizes)
    end
  end
end
