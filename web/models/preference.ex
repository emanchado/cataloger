defmodule Cataloger.Preference do
  use Cataloger.Web, :model
  alias Cataloger.Repo

  schema "preferences" do
    field :name, :string
    field :value, :string

    timestamps
  end

  @required_fields ~w(name value)
  @optional_fields ~w()
  @default_values %{thumbnail_sizes: "128x128 64x64"}

  def get_preference(name) do
    pref_row = Repo.get_by(Cataloger.Preference, name: Atom.to_string(name))
    case pref_row do
      nil ->
        @default_values[name]
      _ ->
        pref_row.value
    end
  end

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
