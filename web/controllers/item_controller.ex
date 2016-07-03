defmodule Cataloger.ItemController do
  use Cataloger.Web, :controller

  alias Cataloger.Item
  alias Cataloger.Section

  plug :scrub_params, "item" when action in [:create, :update]

  def index(conn, _params) do
    items = Repo.all(Item)
    render(conn, "index.html", items: items)
  end

  def new(conn, %{"item" => item_params}) do
    changeset = Item.changeset(%Item{}, item_params)
    section = Repo.get!(Section, item_params["section_id"])
    render(conn, "new.html",
           changeset: changeset,
           page_title: "New item in '#{section.name}'",
           section_id: item_params["section_id"])
  end

  def create(conn, %{"item" => item_params}) do
    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        case process_upload(item_params["cover_image"], "item-#{item.id}") do
          nil ->
            conn
            |> put_flash(:info, "Item created successfully.")
            |> redirect(to: section_path(conn, :show, item.section_id))
          final_path ->
            case Repo.update(Item.changeset(
                      item,
                      %{"id" => item.id, "cover_image_path" => final_path}
                    )) do
              {:ok, _item} ->
                conn
                |> put_flash(:info, "Item created successfully.")
                |> redirect(to: section_path(conn, :show, item.section_id))
              {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)
            end
        end
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    extra_cover_image =
      case process_upload(item_params["cover_image"], "item-#{id}") do
        nil ->
          %{}
        final_path ->
          %{"cover_image_path" => final_path}
      end

    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, Map.merge(item_params, extra_cover_image))

    case Repo.update(changeset) do
      {:ok, item} ->
        redirect(conn, to: section_path(conn, :show, item.section_id))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index))
  end

  defp process_upload(upload, base_filename) do
      case upload do
        nil ->
          nil
        _ ->
          temp_path = upload.path

          original_filename = upload.filename
          original_extension = String.replace(original_filename, ~r/.*\./, "")
          base_image_path = Application.get_env(:cataloger, :store)[:images]
          final_path = Path.join(base_image_path,
                                 base_filename <> "." <> original_extension)

          case File.rename(temp_path, final_path) do
            :ok -> Path.basename(final_path)
            {:error, _reason} -> nil
          end
      end
  end
end
