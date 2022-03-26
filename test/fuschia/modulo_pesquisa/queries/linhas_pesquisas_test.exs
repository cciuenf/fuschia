defmodule Fuschia.ModuloPesquisa.Queries.LinhasPesquisasTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Database
  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisaModel, as: LinhaPesquisa
  alias Fuschia.ModuloPesquisa.Queries.LinhasPesquisaQueries, as: LinhaPesquisas

  @moduletag :unit

  describe "list/0" do
    test "return all linha_pesquisas in database" do
      insert(:linha_pesquisa)

      linha_pesquisa = Database.one(LinhasPesquisas.query())

      assert [linha_pesquisa] == Database.list(LinhasPesquisas.query())
    end
  end

  describe "list_by_nucleo/1" do
    test "return all linha_pesquisas in database" do
      insert(:linha_pesquisa)

      linha_pesquisa = Database.one(LinhasPesquisas.query())

      assert [linha_pesquisa] ==
               linha_pesquisa.nucleo_nome |> LinhasPesquisas.query_by_nucleo() |> Database.list()
    end
  end

  describe "one/1" do
    test "when numero is valid, returns a linha_pesquisa" do
      insert(:linha_pesquisa)

      linha_pesquisa = Database.one(LinhasPesquisas.query())

      assert linha_pesquisa == Database.get(LinhasPesquisas.query(), linha_pesquisa.numero)
    end

    test "when id is invalid, returns nil" do
      assert LinhasPesquisas.query() |> Database.get(0) |> is_nil()
    end
  end

  describe "create/1" do
    @invalid_attrs %{
      numero: nil,
      nucleo_nome: nil,
      descricao_curta: nil,
      descricao_longa: nil
    }

    test "when all params are valid, creates an admin linha_pesquisa" do
      valid_attrs = params_for(:linha_pesquisa)

      assert {:ok, %LinhaPesquisa{}} = Database.create(LinhaPesquisa, valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Database.create(LinhaPesquisa, @invalid_attrs)
    end
  end

  describe "update/1" do
    @update_attrs %{
      numero: 100,
      descricao_curta: "Descricao Curta Teste",
      descricao_longa: "Descricao Longa Teste"
    }

    @invalid_attrs %{
      numero: nil,
      nucleo_nome: nil,
      descricao_curta: nil,
      descricao_longa: nil
    }

    test "when all params are valid, updates a linha_pesquisa" do
      attrs = params_for(:linha_pesquisa)

      assert {:ok, linha_pesquisa} = Database.create(LinhaPesquisa, attrs)

      assert {:ok, updated_linha_pesquisa} =
               Database.update(
                 LinhasPesquisas.query(),
                 &LinhaPesquisa.changeset/2,
                 linha_pesquisa.numero,
                 @update_attrs
               )

      assert updated_linha_pesquisa.numero == @update_attrs.numero
      assert updated_linha_pesquisa.descricao_curta == @update_attrs.descricao_curta
      assert updated_linha_pesquisa.descricao_longa == @update_attrs.descricao_longa
    end

    test "when params are invalid, returns an error changeset" do
      attrs = params_for(:linha_pesquisa)

      assert {:ok, linha_pesquisa} = Database.create(LinhaPesquisa, attrs)

      assert {:error, %Ecto.Changeset{}} =
               Database.update(
                 LinhasPesquisas.query(),
                 &LinhaPesquisa.changeset/2,
                 linha_pesquisa.numero,
                 @invalid_attrs
               )
    end
  end
end
