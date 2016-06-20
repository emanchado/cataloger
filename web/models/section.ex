defmodule Cataloger.Section do
  use Cataloger.Web, :model

  schema "sections" do
    field :name, :string
    field :cover_image_path, :string
    field :description, :string
    belongs_to :catalog, Cataloger.Catalog

    timestamps
  end

  @required_fields ~w(name catalog_id)
  @optional_fields ~w(cover_image_path description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
