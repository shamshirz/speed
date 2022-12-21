defmodule SpeedWeb.FeatureCard do
  use Phoenix.Component

  @doc """
  TODO - add image
  """
  @spec card(%{title: String.t(), description: String.t(), tags: [String.t()], link_href: String.t(), image_src: String.t()}) :: String.t()
  def card(assigns) do
    ~H"""
    <div class="max-w-sm rounded overflow-hidden shadow-lg">
      <a href={@link_href}>
        <img class="w-full" src={@image_src}>
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2"> <%= @title %> </div>
          <p class="text-gray-700 text-base">
            <%= @description %>
          </p>
        </div>
        <div class="px-6 pt-4 pb-2">
        <%= for tag <- @tags do %>
          <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2"> <%= tag %> </span>
        <% end %>
        </div>
      </a>
    </div>
    """
  end
end
