defmodule Speed.Spotify.Credentials do
  use Agent

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

  @doc "The `Agent` is started with an empty `Credentials` struct"
  def start_link(_), do: Agent.start_link(fn -> nil end, name: CredStore)

  @spec get_creds :: Credentials.t()
  def get_creds do
    case Agent.get(CredStore, & &1) do
      nil -> default_creds()
      creds -> creds
    end
  end

  def put_creds(creds) do
    Agent.update(CredStore, fn _ -> creds end)
    creds
  end

  @spec default_creds :: t()
  def default_creds do
    %__MODULE__{
      access_token: Application.fetch_env!(:speed, Speed.Spotify)[:access_token],
      client_id: Application.fetch_env!(:speed, Speed.Spotify)[:client_id],
      client_secret: Application.fetch_env!(:speed, Speed.Spotify)[:client_secret],
      refresh_token: Application.fetch_env!(:speed, Speed.Spotify)[:refresh_token]
    }
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
