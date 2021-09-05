defmodule Fuschia.PesquisadorFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Pesquisador

      def pesquisador_factory do
        campus = insert(:campus)

        %Pesquisador{
          usuario: build(:user),
          minibiografia: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
          tipo_bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
          link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
          orientador_cpf: nil,
          campus_nome: campus.nome
        }
      end
    end
  end
end
