defmodule SpeedWeb.PageController do
  use SpeedWeb, :controller

  def index(conn, _params) do
    cards = [
      %{
        title: "My Spotify Artists",
        description: "My Top Artists loaded Live using Phoenix on Fly.io",
        tags: ["Elixir", "Phoenix", "Liveview", "Spotify"],
        image_src: SpeedWeb.Router.Helpers.static_path(conn, "/images/phoenix.png"),
        link_href: Routes.live_path(conn, SpeedWeb.SpotifyLive)
      },
      %{
        title: "Gumshoe",
        description: "Automated private detective for company data ",
        tags: ["Elixir", "Phoenix", "Liveview"],
        image_src: SpeedWeb.Router.Helpers.static_path(conn, "/images/phoenix.png"),
        link_href: Routes.live_path(conn, SpeedWeb.ResearchLive)
      }
    ]

    render(conn, "index.html", cards: cards)
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
end
