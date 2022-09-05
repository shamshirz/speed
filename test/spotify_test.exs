defmodule Speed.SpotifyTest do
  use ExUnit.Case, async: true

  test "get_top_played!/0" do
    expected = Speed.Constants.fake_top_played() |> Jason.encode!() |> Jason.decode!()
    actual = Speed.Spotify.get_top_played!()

    assert expected == actual
  end
end
