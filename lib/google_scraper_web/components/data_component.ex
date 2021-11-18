defmodule DataComponent do
  use GoogleScraperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="w-full md:w-2/3 p-6 flex flex-col flex-grow flex-shrink">

        <%=live_component SearchComponent, id: :search %>

            <div class="flex flex-col">
                <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
                    <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="table-header-column-title">
                                        Keyword
                                    </th>
                                    <th scope="col" class="table-header-column-title">
                                        Advertisers
                                    </th>
                                    <th scope="col" class="table-header-column-title">
                                        Links
                                    </th>
                                    <th scope="col" class="table-header-column-title">
                                        Results
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <%= for keyword <- @keywords do %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">

                                                <div class="text-sm font-medium text-gray-900">
                                                    <%= keyword.name %>
                                                </div>

                                        </td>

                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                              <div class="ml-4">
                                                  <div class="text-sm text-gray-900">
                                                      <%= keyword.total_advertisers %>
                                                  </div>
                                                </div>
                                            </div>
                                        </td>

                                        <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                          <div class="ml-4">
                                              <div class="text-sm text-gray-900">
                                                  <%= keyword.total_links %>
                                              </div>
                                            </div>
                                        </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <%= keyword.total_results %>
                                        </td>
                                    </tr>
                                    <% end %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
    </div>
    """
  end
end
