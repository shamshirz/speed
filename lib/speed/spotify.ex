defmodule Speed.Spotify do
  @moduledoc """
  3rd Party API Module.
  Single module approach.
  In order to make this runnable with non-live data in the least work type of way
  1. We can use exvcr as is, which handles the test env.
    Slow tests though, I'm not really okay with that
    Possibly it could work for dev too - intercept requests
  2. We can make the URL configurable and send them to localhost during test / dev
    Need to do it with the auth URL too
  3. Have a second module for Local (and another for test?)
    This doesn't solve that the Prod code still needs to get tested
      exvcr
      change the URL and hit the local server (write local server and run in test)
      mock the smallest function possible
        What does that mean?
        Keep the code path as similar as possible, then just replace the actually web call

  Strategy: single code path, no accomodations for non-production
  Cost: 1 module, least code, no option for local dev. Requires a testing solution or you will make live calls.
     Scary

  ## Pro
  * Simple
  * Exactly what is needed and nothing more

  ## Con
  * Hard to test without making real requests
  """

  @spec get_top_played! :: [map()]
  def get_top_played! do
    token = get_auth_token!()

    headers = [
      {"Authorization", token},
      {"Accept", "application/json"},
      {"Content-Type", "application/json"}
    ]

    url = "spotify.com/fakeUrl/top/played"

    # %{body: response} = HTTPoison.get!(url, headers)
    %{body: response} = httpoison_get(url, headers)
    %{"data" => data} = Jason.decode!(response)
    data
  end

  @spec get_auth_token! :: String.t()
  defp get_auth_token! do
    case get_cached_token() do
      {:error, :expired} -> create_auth_token!()
      {:ok, token} -> {:ok, token}
    end
  end

  defp get_cached_token, do: {:error, :expired}

  @spec create_auth_token! :: String.t()
  defp create_auth_token! do
    :timer.sleep(50)
    "auth_token"
  end

  defp httpoison_get(_url, _headers) do
    :timer.sleep(50)
    %{body: Jason.encode!(%{"data" => Speed.Constants.fake_top_played()})}
  end
end
