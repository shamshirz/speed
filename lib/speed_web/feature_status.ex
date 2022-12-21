defmodule SpeedWeb.FeatureStatus do
  use Phoenix.Component

  @doc """
  Invoke

  `<SpeedWeb.FeatureStatus.pill name="DB", online?="true"/>`
  class="pill"
  """
  def pill(assigns) do
    ~H"""
    <p class={@classes}> <%= @name %> </p>
    """
  end
end
