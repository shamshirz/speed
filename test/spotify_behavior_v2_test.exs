defmodule Speed.SpotifyBehaviorV2Test do
  use ExUnit.Case, async: true

  # Not going to test adapters directly because it's only a delegation directly to poison
  # Simple testing strategy - not even a mock necessary unless we want to test particular paths

  test "get_top_played!/0" do
    expected = Speed.Constants.fake_top_played() |> Jason.encode!() |> Jason.decode!()
    actual = Speed.SpotifyBehaviorV2.get_top_played!()

    assert expected == actual
  end
end
