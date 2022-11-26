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
  alias Speed.Spotify.SpotifyBehaviorV3

  use Agent
  @behaviour SpotifyBehaviorV3

  @spec refresh_access_token :: {:ok, Spotify.Credentials.t()} | {:error, any()}
  def refresh_access_token do
    Spotify.Authentication.refresh(get_creds())
  end

  @impl SpotifyBehaviorV3
  def top do
    case Spotify.Personalization.top_artists(get_creds()) do
      {:ok, %{items: artists}} ->
        {:ok, Enum.map(artists, fn artist -> artist.name end)}

      {:ok, %{"error" => %{"message" => "The access token expired", "status" => 401}}} ->
        refresh_access_token() |> put_creds()
        top()

      {:error, error} ->
        {:error, error}
    end
  end

  # TODO - replace by writing to the DB
  @doc "The `Agent` is started with an empty `Credentials` struct"
  def start_link(_) do
    Agent.start_link(fn -> %Spotify.Credentials{} end, name: CredStore)
  end

  @spec get_creds :: Spotify.Credentials.t()
  defp get_creds do
    case Agent.get(CredStore, & &1) do
      %Spotify.Credentials{access_token: nil} -> default_creds()
      creds -> creds
    end
  end

  defp put_creds(creds), do: Agent.update(CredStore, fn _ -> creds end)

  @spec default_creds :: Spotify.Credentials.t()
  defp default_creds do
    Spotify.Credentials.new(
      Application.fetch_env!(:speed, :access_token),
      Application.fetch_env!(:speed, :refresh_token)
    )
  end
end
