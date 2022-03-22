defmodule Fuschia.ModuloPesquisa.Models.CidadeModel do
  @moduledoc """
  Cidade schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.CampusModel
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(municipio)a

  @primary_key {:municipio, CapitalizedString, autogenerate: false}
  schema "cidade" do
    field :id, :string

    has_many :campi, CampusModel, on_replace: :delete, foreign_key: :cidade_municipio

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> unique_constraint(:municipio)
    |> validate_required(@required_fields)
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.CidadeAdapter

    @spec encode(Cidade.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> CidadeAdapter.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
