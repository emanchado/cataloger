defmodule Cataloger.Repo.Migrations.CreateSection do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :name, :string
      add :cover_image_path, :string
      add :catalog_id, references(:catalogs, on_delete: :nothing)

      timestamps
    end
    create index(:sections, [:catalog_id])

  end
end
