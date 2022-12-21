defmodule SpeedWeb.FeatureStatus do
  use Phoenix.Component

  @doc """
  Invoke a la `<SpeedWeb.FeatureStatus.pill { feature }"/>`
  """
  @spec pill(%{name: String.t(), classes: String.t()}) :: String.t()
  def pill(assigns) do
    ~H"""
    <p class={@classes}> <%= @name %> </p>
    """
  end
end
