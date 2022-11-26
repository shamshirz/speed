defmodule Speed.Spotify.SpotifyBehaviorV3 do
  @callback top :: {:ok, [artist_name :: String.t()]} | {:error, any()}
end
