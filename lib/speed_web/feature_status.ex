defmodule SpeedWeb.FeatureStatus do
  use Phoenix.Component

  @doc """
  Invoke a la `<SpeedWeb.FeatureStatus.pill { feature }"/>`
  """
  @spec pill(%{name: String.t(), online?: boolean(), link_href: String.t()}) :: String.t()
  def pill(assigns) do
    ~H"""
    <div class="p-6 max-w-sm mx-auto bg-white rounded-xl shadow-lg flex items-center space-x-4">
      <div class="shrink-0">
        <%= if @online?, do: "✅", else: "🚨" %>
      </div>
      <div>
        <%= Phoenix.HTML.Link.link(@name, to: @link_href, class: "block mt-4 lg:inline-block lg:mt-0 mr-4") %>
      </div>
    </div>
    """
  end
end
