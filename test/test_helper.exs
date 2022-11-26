Mox.defmock(MockSpotifyBehavior, for: Speed.Spotify.SpotifyBehaviorV3)
Application.put_env(:speed, :spotify_client, MockSpotifyBehavior)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Speed.Repo, :manual)
