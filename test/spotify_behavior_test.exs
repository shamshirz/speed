defmodule Speed.SpotifyBehaviorTest do
  use ExUnit.Case, async: true

  describe "SpotifyBehavior" do
    test "get_top_played!/0" do
      expected = Speed.Constants.fake_top_played() |> Jason.encode!() |> Jason.decode!()
      actual = Speed.SpotifyBehavior.get_top_played!()

      assert expected == actual
    end
  end

  describe "SpotifyBehavior.Live" do
    test "get_top_played!/0" do
      expected = Speed.Constants.fake_top_played() |> Jason.encode!() |> Jason.decode!()
      actual = Speed.SpotifyBehavior.Live.get_top_played!()

      assert expected == actual
    end
  end

  @tag :skip
  describe "SpotifyBehavior.Local" do
    test "get_top_played!/0 should be fast" do
      {local_time, _data} = :timer.tc(&Speed.SpotifyBehavior.Local.get_top_played!/0)
      {actual_time, _data} = :timer.tc(&Speed.SpotifyBehavior.Live.get_top_played!/0)

      assert local_time * 10 < actual_time
    end

    test "get_top_played!/0" do
      expected = Speed.Constants.fake_top_played() |> Jason.encode!() |> Jason.decode!()
      actual = Speed.SpotifyBehavior.Local.get_top_played!()

      assert expected == actual
    end
  end
end
