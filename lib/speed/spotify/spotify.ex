defmodule Speed.Spotify do
  defp client, do: Application.get_env(:speed, :spotify_client, Speed.Spotify.Client)

  def top_artists do
    client().top()
  end
end
