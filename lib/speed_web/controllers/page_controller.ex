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
      %{name: "Spotify", success?: spotify_online?, classes: status_to_class(spotify_online?)}
    ]

    if Enum.any?(features, &(&1.success? == false)) do
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
