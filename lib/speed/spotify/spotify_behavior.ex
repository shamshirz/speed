defmodule Speed.Spotify.SpotifyBehavior do
  @callback top :: {:ok, [artist_name :: String.t()]} | {:error, any()}
end
