defmodule CatalogImageExporter do
  alias Cataloger.Repo
  alias Cataloger.Catalog
  alias Cataloger.Preference
  alias Cataloger.Endpoint

  def export_images(catalog_id) do
    catalog = Repo.get!(Catalog, catalog_id)
    catalog_id_str = "#{catalog_id}"
    all_image_paths = Catalog.all_image_paths(catalog)
    base_export_dir = Application.get_env(:cataloger, :export_dir)
    catalog_export_dir = Path.join(base_export_dir, catalog_id_str)
    image_export_dir = Path.join(catalog_export_dir, "images")
    thumbnail_sizes = String.split(Preference.get_preference(:thumbnail_sizes),
                                   " ")

    image_errors = Enum.reduce(all_image_paths, [], fn(image, errors) ->
      t = Task.async(Thumbnailer,
                     :make_thumbnails,
                     [image, image_export_dir, thumbnail_sizes])

      case Task.await(t) do
        :ok ->
          Endpoint.broadcast("catalog:" <> catalog_id_str,
                             "image-export-progress",
                             %{current: image, all_images: all_image_paths})
          errors
        {:error, _e} ->
          [image | errors]
      end
    end)

    case image_errors do
      [] -> :ok
      _  -> {:error, image_errors}
    end
  end
end
