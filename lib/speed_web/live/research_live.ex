defmodule SpeedWeb.ResearchLive do
  use SpeedWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-submit="search">
      <input type="text" name="q" value={@query} list="matches" placeholder="Search..." {%{readonly: @loading}}/>
      <%= if is_binary(@result) do %><pre><%= @result %></pre><% end %>

    </form>
    <%= if is_list(@result) do %>
      <table>
        <tr>
          <th>Legal Name</th>
          <th>Address</th>
          <th>City</th>
          <th>Country</th>
          <th>State</th>
          <th>Zip</th>
          <th>Description</th>
          <th>Domain</th>
          <th>Employees</th>
          <th>Estimated Revenue</th>
          <th>Industry</th>
          <th>Naics</th>
          <th>Source</th>
          <th>Source Url</th>
        </tr>
        <%= for row <- @result do %>
          <tr>
            <td><%= row.legal_name %></td>
            <td><%= row.company_address %></td>
            <td><%= row.company_city %></td>
            <td><%= row.company_country %></td>
            <td><%= row.company_region %></td>
            <td><%= row.company_zip_code %></td>
            <td><%= row.description %></td>
            <td><%= row.domain %></td>
            <td><%= row.employees %></td>
            <td><%= row.estimated_revenue %></td>
            <td><%= row.industry %></td>
            <td><%= row.naics_code %></td>
            <td><%= row.source %></td>
            <td><%= row.source_url %></td>
          </tr>
        <% end %>
      </table>
    <% end %>
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
    %{hits: hits, results: findings} = Speed.Research.company(query)
    IO.puts("Result for #{query}: #{hits} Hits")
    {:noreply, assign(socket, result: findings, loading: false)}
  end
end
