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
  alias Speed.Spotify.SpotifyBehavior

  use Agent
  @behaviour SpotifyBehavior

  @type t :: %__MODULE__{
          access_token: String.t(),
          client_id: String.t(),
          client_secret: String.t(),
          refresh_token: String.t()
        }

  defstruct [
    :access_token,
    :client_id,
    :client_secret,
    :refresh_token
  ]

  @spec refresh_access_token(t()) :: t()
  def refresh_access_token(credentials) do
    case request_refreshed_access_token(credentials) |> IO.inspect(label: "refresh_access_token") do
      %Req.Response{body: %{"access_token" => at}} ->
        %__MODULE__{credentials | access_token: at}

      _anything_else ->
        raise "AHHH"
    end
  end

  def base_url, do: "https://api.spotify.com/v1/me/top/"

  @impl SpotifyBehavior
  def top(creds \\ get_creds()) do
    # IO.inspect(creds, label: "top with these creds")
    url = base_url() <> "artists"
    headers = to_get_headers(creds)

    case Req.get!(url, headers: headers) do
      %Req.Response{status: 200, body: %{"items" => artists}} ->
        {:ok, Enum.map(artists, fn artist -> artist["name"] end)}

      %Req.Response{body: %{"error" => %{"message" => "The access token expired", "status" => 401}}} ->
        creds
        |> refresh_access_token()
        |> put_creds()
        |> top()

      {:error, error} ->
        {:error, error}
    end
  end

  # TODO - replace by writing to the DB
  @doc "The `Agent` is started with an empty `Credentials` struct"
  def start_link(_) do
    Agent.start_link(fn -> nil end, name: CredStore)
  end

  @spec get_creds :: t()
  def get_creds do
    case Agent.get(CredStore, & &1) do
      nil -> default_creds()
      creds -> creds
    end
  end

  defp put_creds(creds) do
    Agent.update(CredStore, fn _ -> creds end)
    creds
  end

  @spec default_creds :: t()
  defp default_creds do
    %__MODULE__{
      access_token: Application.fetch_env!(:speed, Speed.Spotify)[:access_token],
      client_id: Application.fetch_env!(:speed, Speed.Spotify)[:client_id],
      client_secret: Application.fetch_env!(:speed, Speed.Spotify)[:client_secret],
      refresh_token: Application.fetch_env!(:speed, Speed.Spotify)[:refresh_token]
    }
  end

  def refresh_creds do
    creds = get_creds()
    request_refreshed_access_token(creds)
  end

  @spec request_refreshed_access_token(t()) :: Req.Response.t()
  def request_refreshed_access_token(%{refresh_token: rt} = creds) do
    endpoint = "https://accounts.spotify.com/api/token"
    body = "grant_type=refresh_token&refresh_token=#{rt}"

    headers = to_refresh_headers(creds)

    Req.post!(endpoint, body: body, headers: headers)
  end

  @spec to_refresh_headers(t()) :: [{String.t(), String.t()}]
  def to_refresh_headers(%{client_id: ci, client_secret: cs}) do
    encoded_credentials = :base64.encode("#{ci}:#{cs}")

    [
      {"Authorization", "Basic #{encoded_credentials}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end

  @spec to_get_headers(t()) :: [{String.t(), String.t()}]
  def to_get_headers(%{access_token: at}), do: [{"Authorization", "Bearer #{at}"}]
end
