defmodule Fuschia.CidadeFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Fuschia.Entities.Cidade

      def cidade_factory do
        %Cidade{
          municipio: sequence(:municipio, &"Cidade Test #{&1}")
        }
      end
    end
  end
end
