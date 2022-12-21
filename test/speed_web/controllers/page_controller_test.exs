defmodule SpeedWeb.PageControllerTest do
  use SpeedWeb.ConnCase, async: true

  import Mox

  setup :verify_on_exit!

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "GET /status", %{conn: conn} do
    expect(MockSpotifyBehavior, :top, fn -> {:ok, ["Kendrick Lamar", "Bad Bunny"]} end)
    conn = get(conn, "/status")
    assert html_response(conn, 200) =~ "pill-good"
  end
end
