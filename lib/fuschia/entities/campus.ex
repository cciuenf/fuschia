defmodule Fuschia.Entities.Campus do
  @moduledoc """
  Campus Schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.{Cidade, Pesquisador}
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(nome)a

  schema "campus" do
    field :nome, CapitalizedString

    belongs_to :cidade, Cidade,
      type: :string,
      on_replace: :delete,
      references: :municipio,
      foreign_key: :cidade_municipio

    has_many :pesquisadores, Pesquisador, foreign_key: :campus_id

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> cast_assoc(:cidade, required: true)
  end

  def foreign_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:cidade_municipio | @required_fields])
    |> validate_required([:cidade_municipio | @required_fields])
    |> unique_constraint([:nome, :cidade_municipio], name: :campus_nome_municipio_index)
    |> foreign_key_constraint(:cidade_municipio)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        nome: struct.nome,
        cidade: struct.cidade,
        pesquisadores: struct.pesquisadores
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
