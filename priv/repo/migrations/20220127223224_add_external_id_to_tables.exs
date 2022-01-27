defmodule Fuschia.Repo.Migrations.AddExternalIdToTables do
  use Ecto.Migration

  def change do
    for table_name <- tables() do
      alter table(table_name) do
        add :id_externo, :string, null: false
      end
    end
  end

  defp tables do
    ~w(campus cidade linha_pesquisa midia nucleo pesquisador relatorio)
  end
end
