defmodule Fuschia.Repo.Migrations.CreateCampus do
  use Ecto.Migration

  def change do
    create table(:campus) do
      add :nome, :string, null: false

      add :cidade_municipio,
          references(:cidade, column: :municipio, type: :string, on_delete: :delete_all),
          null: false

      timestamps()
    end

    create unique_index(:campus, [:nome, :cidade_municipio], name: :campus_nome_municipio_index)
  end
end
