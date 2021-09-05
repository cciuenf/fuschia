defmodule Fuschia.Repo.Migrations.CreateCidade do
  use Ecto.Migration

  def change do
    create table(:cidade, primary_key: false) do
      add(:municipio, :string, primary_key: true, null: false)

      timestamps()
    end
  end
end
