defmodule Cataloger.SectionTest do
  use Cataloger.ModelCase

  alias Cataloger.Section

  @valid_attrs %{cover_image_path: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Section.changeset(%Section{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Section.changeset(%Section{}, @invalid_attrs)
    refute changeset.valid?
  end
end
