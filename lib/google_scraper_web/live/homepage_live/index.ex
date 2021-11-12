defmodule GoogleScraperWeb.HomepageLive.Index do
  use GoogleScraperWeb, :live_view

  alias GoogleScraper.Keywords

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(keywords: Keywords.list_keywords())
     |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :csv, fn meta, entry ->
      dest = Path.join("priv/static/uploads", "#{entry.uuid}.csv")
      File.cp!(meta.path, dest)
      contents = read_csv(dest)
      # Repo.insert_all(Branch, contents)
    end)

    {:noreply, assign(socket, keywords: Keywords.list_keywords())}
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
    |> List.flatten()
    |> IO.inspect(label: "keyword list")
  end
end
