defmodule Speed.Spotify do
  @doc false
  defp client, do: Application.get_env(:speed, :spotify_client, Speed.Spotify.Client)

  @doc """
  Use the configured adapter to get the latest top artists for the account credentials available.
  """
  @spec top_artists :: [String.t()]
  def top_artists, do: client().top()
end
