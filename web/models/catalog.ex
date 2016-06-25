defmodule Cataloger.Catalog do
  use Cataloger.Web, :model
  alias Cataloger.Repo

  schema "catalogs" do
    field :name, :string
    has_many :sections, Cataloger.Section

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, max: 120)
  end

  def all_image_paths(catalog) do
    base_image_path = Application.get_env(:cataloger, :store)[:images]
    catalog = Repo.preload(catalog, :sections)

    Enum.reduce(catalog.sections, [], fn(section, images) ->
      section = Repo.preload(section, :items)

      section_image = Path.join(base_image_path, section.cover_image_path)
      item_images = Enum.reduce(section.items, [], fn(item, images) ->
        [Path.join(base_image_path, item.cover_image_path) | images]
      end)

      images ++ [section_image] ++ item_images
    end)
  end
end
