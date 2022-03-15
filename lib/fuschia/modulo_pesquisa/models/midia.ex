defmodule Fuschia.ModuloPesquisa.Models.MidiaModel do
  @moduledoc """
  Midia Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.ModuloPesquisa.Models.PesquisadorModel
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
   tipo
   link
   tags
   pesquisador_cpf
  )a

  @tipos_midia ~w(video imagem documento)

  @primary_key {:link, TrimmedString, autogenerate: false}
  schema "midia" do
    field :id, :string
    field :tipo, TrimmedString
    field :tags, {:array, TrimmedString}

    belongs_to :pesquisador, PesquisadorModel,
      references: :usuario_cpf,
      foreign_key: :pesquisador_cpf,
      type: TrimmedString,
      on_replace: :update

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> validate_inclusion(:tipo, @tipos_midia)
    |> foreign_key_constraint(:pesquisador_cpf)
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.MidiaAdapter

    @spec encode(Midia.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> MidiaAdapter.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
