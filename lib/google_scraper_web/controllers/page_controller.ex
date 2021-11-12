defmodule GoogleScraperWeb.PageController do
  use GoogleScraperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
