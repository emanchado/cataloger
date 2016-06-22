defmodule Cataloger.PreferenceTest do
  use Cataloger.ModelCase

  alias Cataloger.Preference

  @valid_attrs %{name: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Preference.changeset(%Preference{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Preference.changeset(%Preference{}, @invalid_attrs)
    refute changeset.valid?
  end
end
