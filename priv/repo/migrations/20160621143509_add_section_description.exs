defmodule Cataloger.Repo.Migrations.AddSectionDescription do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :description, :string
    end
  end
end
