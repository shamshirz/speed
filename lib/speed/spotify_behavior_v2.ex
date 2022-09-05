defmodule Speed.SpotifyBehaviorV2 do
  @moduledoc """
  Behavior based definition - approach API differently, keep most code in primary behavior module

  This is basically making a manual, extremely thin, wrapper around Httpoison

  Strategy: @callback is smallest possible function around side effect
  Cost: 3 modules, most callbacks, smallest impl modules, no testing accomodations needed

  ## Pro
  * Impl modules are so simple that they don't need testing
  * Because behavior is available - we can mock in a test
  * We can also provide an exvcr test if we wanted

  ## Con
  * Slightly longer than other behavior and original
    * need to provide a callback for every side effect

  """

  # This seems pretty specific to prod…
  # Maybe that's okay because we aren't making multiple implementations, we just want to be able to mock some functions
  # We are making a callback of ALL side effects so we can mock them…
  @callback data_request!(url :: String.t(), headers :: [any()]) :: %{body: map()}

  @callback auth_request!(url :: String.t(), headers :: [any()]) :: %{body: map()}

  defp adapter, do: Application.get_env(:speed, :spotify_adapter, Speed.SpotifyBehaviorV2.Local)

  @spec get_top_played! :: [map()]
  def get_top_played! do
    token = get_auth_token!()

    headers = [
      {"Authorization", token},
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    url = "spotify.com/fakeUrl/top/played"

    %{body: response} = adapter().data_request!(url, headers)
    %{"data" => data} = Jason.decode!(response)
    data
  end

  @spec get_auth_token! :: String.t()
  def get_auth_token! do
    case get_cached_token() do
      {:error, :expired} -> create_auth_token!("spotify.com/auth", header: "a")
      {:ok, token} -> {:ok, token}
    end
  end

  def get_cached_token, do: {:error, :expired}

  @spec create_auth_token!(String.t(), [any()]) :: String.t()
  def create_auth_token!(url, headers), do: adapter().auth_request!(url, headers)
end

defmodule Speed.SpotifyBehaviorV2.Live do
  @moduledoc """
  This is our original Spotify Module
  """
  @behaviour Speed.SpotifyBehaviorV2

  @impl Speed.SpotifyBehaviorV2
  def data_request!(url, headers), do: HTTPoison.get!(url, headers)

  @impl Speed.SpotifyBehaviorV2
  def auth_request!(url, headers), do: HTTPoison.post!(url, headers)
end

defmodule Speed.SpotifyBehaviorV2.Local do
  @moduledoc """
  This is basically test code, and you need to keep it up to date with real prod code
  """
  @behaviour Speed.SpotifyBehaviorV2

  @impl Speed.SpotifyBehaviorV2
  def data_request!(_url, _headers),
    do: %{body: Jason.encode!(%{"data" => Speed.Constants.fake_top_played()})}

  @impl Speed.SpotifyBehaviorV2
  def auth_request!(_url, _headers), do: "Auth Token"
end
