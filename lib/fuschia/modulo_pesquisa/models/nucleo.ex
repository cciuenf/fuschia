defmodule Fuschia.ModuloPesquisa.Models.NucleoModel do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisaModel
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(nome descricao)a

  @primary_key {:nome, CapitalizedString, []}
  schema "nucleo" do
    field :id, :string
    field :descricao, :string

    has_many :linhas_pesquisa, LinhaPesquisaModel, foreign_key: :nucleo_nome

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:descricao, max: 400)
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.NucleoAdapter

    @spec encode(Nucleo.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> NucleoAdapter.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
