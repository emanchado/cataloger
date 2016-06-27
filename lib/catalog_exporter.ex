defmodule CatalogExporter do
  alias Cataloger.Repo
  alias Cataloger.Catalog
  alias Cataloger.Preference
  alias Cataloger.Endpoint

  def export_structure(catalog_id) do
    catalog = Repo.get!(Catalog, catalog_id) |> Repo.preload(:sections)
    catalog_id_str = "#{catalog_id}"

    section_structure = Enum.reduce(catalog.sections, [], fn(section, struct) ->
      section = Repo.preload(section, :items)
      items = Enum.reduce(section.items, [], fn(item, item_struct) ->
        item_struct ++ [%{name: item.name,
                          description: item.description,
                          cover_image_path: item.cover_image_path,
                          tags: String.split(item.tags, ", ")}]
      end)

      Endpoint.broadcast("catalog:" <> catalog_id_str,
                         "structure-export-progress",
                         %{current: section.name,
                           number_sections: Enum.count(catalog.sections)})

      struct ++ [%{name: section.name, items: items}]
    end)

    %{name: catalog.name, sections: section_structure}
  end

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
                             %{current: image,
                               number_images: Enum.count(all_image_paths)})
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
