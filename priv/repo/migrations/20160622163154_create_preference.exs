defmodule Cataloger.Repo.Migrations.CreatePreference do
  use Ecto.Migration

  def change do
    create table(:preferences) do
      add :name, :string
      add :value, :string

      timestamps
    end

  end
end
