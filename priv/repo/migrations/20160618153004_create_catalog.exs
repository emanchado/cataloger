defmodule Cataloger.Repo.Migrations.CreateCatalog do
  use Ecto.Migration

  def change do
    create table(:catalogs) do
      add :name, :string

      timestamps
    end

  end
end
