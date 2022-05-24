defmodule FuschiaWeb.Components.Footer do
  @moduledoc false

  use FuschiaWeb, :surface_component

  def render(assigns) do
    ~F"""
    <footer class="footer footer-center p-4 bg-white">
      <img src="/images/footer_logo.png" alt={alt_text()} class="w-1/2" />
    </footer>
    """
  end

  def alt_text do
    """
    Bloco de logos das instiuições relacionadas
    ao projeto Pescarte: IPEAD; UENF; Petrobras;
    e Ibama.
    """
  end
end
