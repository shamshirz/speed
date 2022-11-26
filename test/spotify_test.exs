defmodule Speed.SpotifyTest do
  use Speed.DataCase, async: true

  import Mox

  setup :verify_on_exit!

  describe "top_artists/0" do
    test "fetches a list of artists" do
      expect(MockSpotifyBehavior, :top, fn -> {:ok, ["Kendrick Lamar", "Bad Bunny"]} end)

      assert {:ok, returned} = Speed.Spotify.top_artists()
      assert length(returned) == 2
    end

    test "falls back to Mock stub" do
      assert {:ok, returned} = Speed.Spotify.top_artists()
      assert length(returned) == 3
    end
  end
end
