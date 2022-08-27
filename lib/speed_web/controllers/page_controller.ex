defmodule SpeedWeb.PageController do
  use SpeedWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
