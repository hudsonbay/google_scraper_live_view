defmodule GoogleScraperWeb.HomepageLive.Index do
  @moduledoc """
  Module to handle main LiveView logic
  """
  use GoogleScraperWeb, :live_view

  alias GoogleScraper.Keywords

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    user = GoogleScraper.Accounts.get_user_by_session_token(session["user_token"])

    if(connected?(socket), do: Keywords.subscribe())

    {:ok,
     socket
     |> assign(%{
       keyword: "",
       user: user,
       loading: false,
       error_message: "",
       keywords: Keywords.list_keywords_by_user(user.id),
       session_id: session["live_socket_id"]
     })
     |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    csv_file =
      consume_uploaded_entries(socket, :csv, fn meta, entry ->
        dest = Path.join("priv/static/uploads", "#{entry.uuid}.csv")
        File.cp!(meta.path, dest)
        dest
      end)

    case CSVOperations.provide_valid_csv(csv_file) do
      %{"csv" => content, "errors" => []} ->
        send(self(), {:fetch_from_google, content})
        {:noreply, assign(socket, loading: true, error_message: "")}

      %{"errors" => errors} ->
        socket =
          socket
          |> assign(loading: false, error_message: CSVOperations.format_csv_errors(errors))

        {:noreply, socket}
    end
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

  @impl Phoenix.LiveView
  def handle_info({:fetch_from_google, contents}, socket) do
    user_id = socket.assigns.user.id
    view = self()

    Task.start(fn ->
      GoogleScraper.fetch_results(contents, user_id)
      send(view, :fetch_from_google_complete)
    end)

    {:noreply, socket}
  end

  def handle_info(:fetch_from_google_complete, socket) do
    {:noreply, assign(socket, loading: false)}
  end

  @impl Phoenix.LiveView
  def handle_info(
        {:keyword_created,
         %{
           name: name,
           total_advertisers: total_advertisers,
           total_links: total_links,
           total_results: total_results,
           user_id: user_id
         }},
        socket
      ) do
    {:noreply,
     update(socket, :keywords, fn keywords ->
       [
         keywords
         | [
             %{
               name: name,
               total_advertisers: total_advertisers,
               total_links: total_links,
               total_results: total_results,
               user_id: user_id
             }
           ]
       ]
       |> List.flatten()
     end)}
  end
end
