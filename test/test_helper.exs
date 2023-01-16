Mox.defmock(MockSpotifyBehavior, for: Speed.Spotify.SpotifyBehavior)
Application.put_env(:speed, :spotify_client, MockSpotifyBehavior)

Mox.defmock(MockSlackClient, for: Slack.Web.Client)
Application.put_env(:slack, :web_http_client, MockSlackClient)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Speed.Repo, :manual)
