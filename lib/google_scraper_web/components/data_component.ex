defmodule DataComponent do
  use GoogleScraperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="w-full md:w-2/3 p-6 flex flex-col flex-grow flex-shrink">
          <table class="table-auto border border-collapse">
            <thead>
              <tr>
                <th class="border-2 border-black-600">KEYWORD</th>
                <th class="border-2">ADVERTISERS</th>
                <th class="border-2">LINKS</th>
                <th class="border-2">RESULTS</th>
              </tr>
            </thead>
            <tbody>
            <%= for keyword <- @keywords do %>
            <tr class="bg-emerald-200">
              <td class="border"><%= keyword.name %></td>
              <td class="border"><%= keyword.branch_id %></td>
              <td class="border"><%= keyword.part_price %></td>
              <td class="border"><%= keyword.short_desc %></td>
            </tr>
            <% end %>
            </tbody>
          </table>
    </div>
    """
  end
end
