defmodule Cataloger.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :string
      add :cover_image_path, :string
      add :section_id, references(:sections, on_delete: :nothing)

      timestamps
    end
    create index(:items, [:section_id])

  end
end
