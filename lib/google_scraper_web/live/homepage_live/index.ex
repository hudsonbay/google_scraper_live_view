defmodule GoogleScraperWeb.HomepageLive.Index do
  use GoogleScraperWeb, :live_view



  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
    #  |> assign(branches: Branches.list_branches())
     |> allow_upload(:csv, accept: ~w(.csv), max_entries: 1)}
  end

  # @impl Phoenix.LiveView
  # def handle_event("save", _params, socket) do
  #   consume_uploaded_entries(socket, :csv, fn meta, entry ->
  #     dest = Path.join("priv/static/uploads", "#{entry.uuid}.csv")
  #     File.cp!(meta.path, dest)
  #     contents = read_csv(dest)
  #     Repo.insert_all(Branch, contents)
  #   end)

  #   {:noreply, assign(socket, branches: Branches.list_branches())}
  # end

  # @impl Phoenix.LiveView
  # def handle_event("validate", _params, socket) do
  #   {:noreply, socket}
  # end

  # defp read_csv(file) do
  #   file
  #   |> File.stream!()
  #   |> CSV.decode(separator: ?|, headers: true)
  #   |> Enum.map(fn {:ok, branch} -> branch end)
  #   |> format_content()
  # end

  # defp format_content(branch_list_map) do
  #   branch_list_map
  #   |> Enum.map(fn map ->
  #     formatted_map =
  #       map
  #       |> Map.new(fn {k, v} -> {String.downcase(k), v} end)
  #       |> Utils.cast_map()

  #     %{formatted_map | part_price: Decimal.new(formatted_map[:part_price])}
  #   end)
  # end
end
