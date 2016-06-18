defmodule Cataloger.SectionControllerTest do
  use Cataloger.ConnCase

  alias Cataloger.Section
  @valid_attrs %{cover_image_path: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, section_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sections"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, section_path(conn, :new)
    assert html_response(conn, 200) =~ "New section"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, section_path(conn, :create), section: @valid_attrs
    assert redirected_to(conn) == section_path(conn, :index)
    assert Repo.get_by(Section, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, section_path(conn, :create), section: @invalid_attrs
    assert html_response(conn, 200) =~ "New section"
  end

  test "shows chosen resource", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = get conn, section_path(conn, :show, section)
    assert html_response(conn, 200) =~ "Show section"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, section_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = get conn, section_path(conn, :edit, section)
    assert html_response(conn, 200) =~ "Edit section"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = put conn, section_path(conn, :update, section), section: @valid_attrs
    assert redirected_to(conn) == section_path(conn, :show, section)
    assert Repo.get_by(Section, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = put conn, section_path(conn, :update, section), section: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit section"
  end

  test "deletes chosen resource", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = delete conn, section_path(conn, :delete, section)
    assert redirected_to(conn) == section_path(conn, :index)
    refute Repo.get(Section, section.id)
  end
end
