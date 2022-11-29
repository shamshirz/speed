defmodule SpeedWeb.SpotifyLive do
  use SpeedWeb, :live_view

  @type data ::
          {:ok, [artist_name :: String.t()]}
          | {:error, String.t()}
          | :loading

  def render(assigns) do
    ~H"""
    <div>
      <%= display_data(@data) %>
    </div>
    """
  end

  @spec display_data(data()) :: String.t()
  def display_data(data) do
    case data do
      {:ok, artists} ->
        artists
        |> Enum.join(", ")

      {:error, error} ->
        error

      :loading ->
        "Loading..."
    end
  end

  def mount(_params, _session, socket) do
    send(self(), :load)
    {:ok, assign(socket, data: :loading)}
  end

  def handle_info(:load, socket) do
    result = Speed.Spotify.top_artists()
    {:noreply, assign(socket, data: result)}
  end
end
