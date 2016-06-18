defmodule Cataloger.CatalogControllerTest do
  use Cataloger.ConnCase

  alias Cataloger.Catalog
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, catalog_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing catalogs"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, catalog_path(conn, :new)
    assert html_response(conn, 200) =~ "New catalog"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, catalog_path(conn, :create), catalog: @valid_attrs
    assert redirected_to(conn) == catalog_path(conn, :index)
    assert Repo.get_by(Catalog, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, catalog_path(conn, :create), catalog: @invalid_attrs
    assert html_response(conn, 200) =~ "New catalog"
  end

  test "shows chosen resource", %{conn: conn} do
    catalog = Repo.insert! %Catalog{}
    conn = get conn, catalog_path(conn, :show, catalog)
    assert html_response(conn, 200) =~ "Show catalog"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, catalog_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    catalog = Repo.insert! %Catalog{}
    conn = get conn, catalog_path(conn, :edit, catalog)
    assert html_response(conn, 200) =~ "Edit catalog"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    catalog = Repo.insert! %Catalog{}
    conn = put conn, catalog_path(conn, :update, catalog), catalog: @valid_attrs
    assert redirected_to(conn) == catalog_path(conn, :show, catalog)
    assert Repo.get_by(Catalog, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    catalog = Repo.insert! %Catalog{}
    conn = put conn, catalog_path(conn, :update, catalog), catalog: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit catalog"
  end

  test "deletes chosen resource", %{conn: conn} do
    catalog = Repo.insert! %Catalog{}
    conn = delete conn, catalog_path(conn, :delete, catalog)
    assert redirected_to(conn) == catalog_path(conn, :index)
    refute Repo.get(Catalog, catalog.id)
  end
end
