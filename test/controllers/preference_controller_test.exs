defmodule Cataloger.PreferenceControllerTest do
  use Cataloger.ConnCase

  alias Cataloger.Preference
  @valid_attrs %{name: "some content", value: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, preference_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing preferences"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, preference_path(conn, :new)
    assert html_response(conn, 200) =~ "New preference"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, preference_path(conn, :create), preference: @valid_attrs
    assert redirected_to(conn) == preference_path(conn, :index)
    assert Repo.get_by(Preference, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, preference_path(conn, :create), preference: @invalid_attrs
    assert html_response(conn, 200) =~ "New preference"
  end

  test "shows chosen resource", %{conn: conn} do
    preference = Repo.insert! %Preference{}
    conn = get conn, preference_path(conn, :show, preference)
    assert html_response(conn, 200) =~ "Show preference"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, preference_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    preference = Repo.insert! %Preference{}
    conn = get conn, preference_path(conn, :edit, preference)
    assert html_response(conn, 200) =~ "Edit preference"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    preference = Repo.insert! %Preference{}
    conn = put conn, preference_path(conn, :update, preference), preference: @valid_attrs
    assert redirected_to(conn) == preference_path(conn, :show, preference)
    assert Repo.get_by(Preference, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    preference = Repo.insert! %Preference{}
    conn = put conn, preference_path(conn, :update, preference), preference: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit preference"
  end

  test "deletes chosen resource", %{conn: conn} do
    preference = Repo.insert! %Preference{}
    conn = delete conn, preference_path(conn, :delete, preference)
    assert redirected_to(conn) == preference_path(conn, :index)
    refute Repo.get(Preference, preference.id)
  end
end
