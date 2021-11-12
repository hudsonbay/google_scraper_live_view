defmodule GoogleScraperWeb.PageControllerTest do
  use GoogleScraperWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Google web scraper"
  end
end
