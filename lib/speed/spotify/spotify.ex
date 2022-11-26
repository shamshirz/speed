defmodule Speed.Spotify do
  @callback top :: {:ok, [artist_name :: String.t()]} | {:error, any()}

  defp client, do: Application.get_env(:speed, :spotify_client, Speed.Spotify.Client)

  def top_artists do
    client().top()
  end
end
