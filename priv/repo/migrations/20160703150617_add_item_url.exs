defmodule Cataloger.Repo.Migrations.AddItemUrl do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :url, :string
    end
  end
end
