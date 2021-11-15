defmodule GoogleScraperWeb.HomepageLive.Index do
  use GoogleScraperWeb, :live_view

  alias GoogleScraper.Keywords
  alias GoogleScraper.Spider.Google
  alias GoogleScraper.Keywords.Keyword

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       keyword: "",
       keywords: Keywords.list_keywords()
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

    results = Google.fetch_results(contents)

    Keywords.bulk_create_keywords(Keyword, results)

    {:noreply, assign(socket, keywords: Keywords.list_keywords())}
  end

  @impl Phoenix.LiveView
  def handle_event("search", _params = %{"keyword" => keyword}, socket) do
    socket = assign(socket, keyword: keyword, keywords: Keywords.search_by_name(keyword))

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
