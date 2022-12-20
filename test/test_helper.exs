Mox.defmock(MockSpotifyBehavior, for: Speed.Spotify.SpotifyBehavior)
Application.put_env(:speed, :spotify_client, MockSpotifyBehavior)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Speed.Repo, :manual)
