defmodule FuschiaWeb.LiveComponents.Navbar.MenuLinks do
  @moduledoc """
  Componente que agrupa os links para a Navbar
  """

  use FuschiaWeb, :surface_component

  # alias Fuschia.Accounts.Models.UserModel
  alias FuschiaWeb.LiveComponents.Icon
  alias FuschiaWeb.LiveComponents.Navbar.MenuItem
  alias FuschiaWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.Socket

  @doc "Conexão atual"
  prop socket, :struct, required: true

  def is_current_path?(%Plug.Conn{} = conn, to) do
    [path] = conn.path_info

    to =~ path
  end

  def is_current_path?(%Socket{} = socket, to) do
    socket.assigns.uri.path =~ to
  end

  def guest_menu(socket) do
    login_path = Routes.user_session_path(socket, :new)

    [
      build_menu_item("projeto", "/projeto"),
      build_menu_item("contato", "/contato"),
      build_menu_item("censo da pesca", "/censo"),
      build_dropdown("galeria", [
        build_menu_item("fotos", "/galeria/fotos"),
        build_menu_item("vídeos", "/galeria/videos"),
        build_menu_item("documentos", "/galeria/documentos"),
        build_menu_item("relatórios", "/galeria/relatorios"),
        build_menu_item("podcast", "/galeria/podcast")
      ]),
      build_dropdown("setores", [
        build_menu_item("campo", "/campo"),
        build_menu_item("pesquisa", "/pesquisa"),
        build_menu_item("pedagógico", "/pedagogico")
      ]),
      build_dropdown("extras", [
        build_menu_item("museu da pesca", "/museu-da-pesca"),
        build_menu_item("pgtrs", "/pgtrs"),
        build_menu_item("agenda socioambiental", "/agenda-socioambiental")
      ]),
      build_menu_item("acessar", login_path)
    ]
  end

  def authenticated_menu(socket) do
    logout_path = Routes.user_session_path(socket, :delete)

    [
      build_menu_item("perfil", "/app/perfil"),
      build_menu_item("relatórios", "/app/relatorios"),
      build_menu_item("mídias", "/app/midias"),
      build_menu_item("agenda", "/app/agenda"),
      build_menu_item("notificações", "/app/notificacoes"),
      build_menu_item("sair", logout_path, :delete)
    ]
  end

  defp build_menu_item(label, path, method \\ :get) do
    Map.new()
    |> Map.put(:path, path)
    |> Map.put(:label, label)
    |> Map.put(:method, method)
    |> Map.put(:type, :link)
  end

  defp build_dropdown(label, items) do
    Map.new()
    |> Map.put(:label, label)
    |> Map.put(:items, items)
    |> Map.put(:type, :dropdown)
  end
end
