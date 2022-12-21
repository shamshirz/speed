defmodule SpeedWeb.PageController do
  use SpeedWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def status(conn, _params) do
    spotify_online? =
      case Speed.Spotify.top_artists() do
        {:ok, _} -> true
        _ -> false
      end

    features = [
      %{name: "Spotify", online?: spotify_online?, link_href: Routes.live_path(conn, SpeedWeb.SpotifyLive)}
    ]

    if Enum.any?(features, &(&1.online? == false)) do
      conn
      |> put_status(500)
      |> render("status.html", features: features)
    else
      render(conn, "status.html", features: features)
    end
  end

  defp status_to_class(true), do: "pill pill-good"
  defp status_to_class(false), do: "pill pill-bad"
end
