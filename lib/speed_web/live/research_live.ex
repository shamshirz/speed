defmodule SpeedWeb.ResearchLive do
  use SpeedWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-submit="search">
      <input type="text" name="q" value={@query} list="matches" placeholder="Search..." {%{readonly: @loading}}/>
      <%= if is_binary(@result) do %><pre><%= @result %></pre><% end %>
      <%= if is_map(@result) do %>
        <ul>
          <li> primary_name -> <%= @result.primary_name %> </li>
          <li> company_address -> <%= @result.company_address %> </li>
          <li> company_city -> <%= @result.company_city %> </li>
          <li> company_country -> <%= @result.company_country %> </li>
          <li> company_region -> <%= @result.company_region %> </li>
          <li> country_region -> <%= @result.country_region %> </li>
          <li> company_zip_code -> <%= @result.company_zip_code %> </li>
          <li> industry_name -> <%= @result.industry_name %> </li>
          <li> Raw Data -> <a href={"https://www.dnb.com" <> @result.company_profile_link }> DNB Record for <%= @result.primary_name %> </a>  </li>
        </ul>
      <% end %>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: nil, result: nil, loading: false)}
  end

  def handle_event("search", %{"q" => query}, socket) when byte_size(query) <= 100 do
    send(self(), {:search, query})
    {:noreply, assign(socket, query: query, result: "Searching...", loading: true)}
  end

  def handle_info({:search, query}, socket) do
    case Research.company(query) do
      {:ok, result} ->
        {:noreply, assign(socket, result: result, loading: false)}

      {:error, reason} ->
        {:noreply, assign(socket, result: reason, loading: false)}
    end
  end
end
