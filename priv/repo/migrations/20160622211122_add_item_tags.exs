defmodule Cataloger.Repo.Migrations.AddItemTags do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :tags, :string
    end
  end
end
