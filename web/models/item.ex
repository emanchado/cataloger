defmodule Cataloger.Item do
  use Cataloger.Web, :model

  schema "items" do
    field :name, :string
    field :description, :string
    field :cover_image_path, :string
    belongs_to :section, Cataloger.Section

    timestamps
  end

  @required_fields ~w(name description section_id)
  @optional_fields ~w(cover_image_path)

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
