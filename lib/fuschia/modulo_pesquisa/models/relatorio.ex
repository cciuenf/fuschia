defmodule Fuschia.ModuloPesquisa.Models.Relatorio do
  @moduledoc """
  Relatorio Schema
  """

  use Fuschia.Schema

  import Ecto.Changeset
  import Fuschia.ModuloPesquisa.Logic.Relatorio

  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
    ano
    mes
    tipo
    pesquisador_id
    raw_content
  )a

  @optional_fields ~w(link)a

  @tipos ~w(mensal trimestral anual)a

  @derive Jason.Encoder
  @primary_key {:id, :string, autogenerate: false}
  schema "relatorio" do
    field :ano, :integer
    field :mes, :integer
    field :tipo, Ecto.Enum, values: @tipos
    field :link, TrimmedString
    field :raw_content, TrimmedString

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_month(:mes)
    |> validate_year(:ano)
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:id, Nanoid.generate())
  end
end
