defmodule Speed.SpotifyBehaviorTest do
  use Speed.Case, async: true

  import Mox

  setup :verify_on_exit!

  describe "SpotifyBehavior" do
    test "falls back to mox stub" do
      assert {:ok, returned} = Speed.Spotify.top_artists()
      assert length(returned) == 3
    end
  end
end
