defmodule Speed.SpotifyBehavior do
  @moduledoc """
  Behavior based definition

  Strategy: @callback is as generic as possible, allowing completely different impl
  Cost: 3 modules, least callbacks, small impl modules, testing required at the impl module level

  ## Pro
  * Local dev can have different behavior than production
  *

  ## Con
  * This module has code that isn't used in production
    * More code to maintain and test - need to specifically test the prod version separately

  """

  @callback get_top_played! :: [map()]

  @doc """
  Dynamic Dispath.
  At this point, why is it a behavior rather than a protocol?
    Because it's not based on a data type
  """
  @spec get_top_played! :: String.t()
  def get_top_played! do
    adapter = Application.get_env(:speed, :spotify_adapter, Speed.SpotifyBehavior.Local)
    adapter.get_top_played!
  end
end

defmodule Speed.SpotifyBehavior.Live do
  @moduledoc """
  This is our original Spotify Module
  """
  @behaviour Speed.SpotifyBehavior

  @impl Speed.SpotifyBehavior
  def get_top_played! do
    Speed.Spotify.get_top_played!()
  end
end

defmodule Speed.SpotifyBehavior.Local do
  @behaviour Speed.SpotifyBehavior

  @impl Speed.SpotifyBehavior
  def get_top_played!, do: Speed.Constants.fake_top_played() |> Jason.encode!() |> Jason.decode!()
end
