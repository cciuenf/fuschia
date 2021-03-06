defmodule FuschiaWeb.Components.Navbar.MenuLogo do
  @moduledoc false

  use FuschiaWeb, :component

  def render(assigns) do
    ~H"""
    <figure>
      <img
        class={get_hidden_style(@hidden?)}
        src="/images/pescarte_logo.png"
        alt="Logo completo do projeto com os dez peixinhos e nome"
        align="middle"
        width="200"
      />
    </figure>
    """
  end

  def get_hidden_style(true), do: "lg:hidden"
  def get_hidden_style(false), do: ""
end
