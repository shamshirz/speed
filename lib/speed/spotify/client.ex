defmodule Speed.Spotify.Client do
  @moduledoc """
  The SpotifyClient module is responsible for making requests to the Spotify API.

  We use the Authorization Code Flow path to get an access token and refresh token for the app to access my personal spotify.
  The App has it's own client_id and client_secret and then we give permission to my personal Spotify
  which is stored in the `access_token` and `refresh_token`.

  https://developer.spotify.com/documentation/general/guides/authorization/code-flow/

  * Call `/authorize` endpoint to get the `code`
  * Call `/token` endpoint to get the `access_token` and `refresh_token`
  * Call `/api/token` with the code to get the `access_token` and `refresh_token`
  * Occasional calls to `/api/token` with the `refresh_token` to get a new `access_token`

  `Spotify.Credentials` has an example of exactly how this works.

  # Manually create refresh token for my spotify account!

  ## Response
  http://localhost/callback?code=<code here>

  ## Next step
  curl -H "Authorization: Basic <client_n_secret>" -d grant_type=authorization_code -d code=<code> -d redirect_uri=http://localhost/callback https://accounts.spotify.com/api/token
  """
  alias Speed.Spotify.{SpotifyBehavior, Credentials}

  @behaviour SpotifyBehavior

  @impl SpotifyBehavior
  def top(creds \\ Credentials.get_creds()) do
    # IO.inspect(creds, label: "top with these creds")
    url = base_url() <> "artists"
    headers = Credentials.to_get_headers(creds)

    case Req.get!(url, headers: headers) do
      %Req.Response{status: 200, body: %{"items" => artists}} ->
        {:ok, Enum.map(artists, fn artist -> artist["name"] end)}

      %Req.Response{body: %{"error" => %{"message" => "The access token expired", "status" => 401}}} ->
        creds
        |> refresh_access_token()
        |> Credentials.put_creds()
        |> top()

      {:error, error} ->
        {:error, error}
    end
  end

  def base_url, do: "https://api.spotify.com/v1/me/top/"

  @spec test_connection(Credentials.t(), Keyword.t()) :: boolean()
  def test_connection(creds \\ Credentials.get_creds(), options \\ [retry: true]) do
    url = "https://api.spotify.com/v1/me"
    headers = Credentials.to_get_headers(creds)

    case Req.get!(url, headers: headers) do
      %Req.Response{status: 200} ->
        true

      %Req.Response{body: %{"error" => %{"message" => "The access token expired", "status" => 401}}} ->
        if options[:retry] do
          creds
          |> refresh_access_token()
          |> Credentials.put_creds()
          |> test_connection(retry: false)
        else
          false
        end

      response ->
        IO.inspect(response)
        false
    end
  end

  @spec refresh_access_token(Credentials.t()) :: Credentials.t()
  defp refresh_access_token(credentials) do
    case request_refreshed_access_token(credentials) |> IO.inspect(label: "refresh_access_token") do
      %Req.Response{body: %{"access_token" => at}} ->
        %Credentials{credentials | access_token: at}

      _anything_else ->
        raise "AHHH"
    end
  end

  @spec request_refreshed_access_token(Credentials.t()) :: Req.Response.Credentials.t()
  def request_refreshed_access_token(%{refresh_token: rt} = creds) do
    endpoint = "https://accounts.spotify.com/api/token"
    body = "grant_type=refresh_token&refresh_token=#{rt}"

    headers = Credentials.to_refresh_headers(creds)

    Req.post!(endpoint, body: body, headers: headers)
  end
end
