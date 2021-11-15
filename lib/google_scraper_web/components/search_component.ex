defmodule SearchComponent do
  use GoogleScraperWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center mr-6 my-3">
      <input type="search" class="bg-purple-white shadow rounded border-0 p-3" placeholder="Search by name...">
    </div>
    """
  end
end
