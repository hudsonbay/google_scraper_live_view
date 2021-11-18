defmodule GoogleScraperWeb.PageControllerTest do
  use GoogleScraperWeb.ConnCase

  test "GET / sends you to the login page", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "<html><body>You are being <a href=\"/users/log_in\">redirected</a>.</body></html>"
  end
end
