defmodule GoogleScraperWeb.HomepageLive.Index do
  @moduledoc """
  Module to handle main LiveView logic
  """
  use GoogleScraperWeb, :live_view

  alias GoogleScraper.Keywords

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    user = GoogleScraper.Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(
       keyword: "",
       user: user,
       keywords: Keywords.list_keywords_by_user(user.id),
       session_id: session["live_socket_id"]
     )
     |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    contents =
      consume_uploaded_entries(socket, :csv, fn meta, entry ->
        dest = Path.join("priv/static/uploads", "#{entry.uuid}.csv")
        File.cp!(meta.path, dest)
        read_csv(dest)
      end)
      |> List.flatten()

    user_id = socket.assigns.user.id
    results = GoogleScraper.fetch_results(contents, user_id)

    IO.inspect(results, label: "results")

    if results != [nil] do
      Keywords.bulk_create_keywords(GoogleScraper.Keywords.Keyword, results)
    end

    {:noreply, assign(socket, keywords: Keywords.list_keywords_by_user(user_id))}
  end

  @impl Phoenix.LiveView
  def handle_event("search", %{"keyword" => keyword} = _params, socket) do
    socket =
      assign(
        socket,
        keyword: keyword,
        keywords: Keywords.search_by_name(keyword, socket.assigns.user.id)
      )

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  defp read_csv(file) do
    file
    |> File.stream!()
    |> CSV.decode()
    |> Enum.map(fn {:ok, keyword} -> keyword end)
  end
end
