defmodule Fuschia.NucleoFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.ModuloPesquisa.Models.NucleoModel

      @spec nucleo_factory :: Nucleo.t()
      def nucleo_factory do
        %NucleoModel{
          id: Nanoid.generate_non_secure(),
          nome: sequence(:nome, &"Nucleo #{&1}"),
          descricao: sequence(:descricao, &"Descricao Nucleo #{&1}")
        }
      end
    end
  end
end
