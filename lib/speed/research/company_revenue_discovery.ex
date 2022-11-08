defmodule Speed.Research.CompanyRevenueDiscovery do
  @moduledoc """
  This Module is an experimental tool to guess client information.
  The goal is to collect as much information as possible in an automated way to assist
  in the manual collection of information.
  """

  @doc """
  https://www.lookupcompanyrevenue.com
  """
  @spec search(String.t()) :: String.t()
  def search(company) do
    params = [
      {"companyName", company},
      {"zipCode", ""},
      {"industry", ""},
      {"revenueRange", "Any"},
      {"employeeRange", "Any"},
      {"state", "Any"},
      {"start_index", "0"},
      {"order_by", "revenue_estimate-column"},
      {"order_dir", "desc"}
    ]

    response = Req.get!("https://www.lookupcompanyrevenue.com/search/", params: params)
    # IO.inspect(response, label: "Lookup Company Revenue Response")
    parse_revenue_html(response.body, company)
  end

  @spec parse_revenue_html(String.t(), company :: String.t()) ::
          {:ok, CompanyInfo.t()} | {:error, String.t()}
  def parse_revenue_html(html, company) do
    with {:ok, document} <- Floki.parse_document(html),
         rows = Floki.find(document, "td"),
         rows when length(rows) == 8 <- Enum.take(rows, 8) do
      {:ok, to_finding(rows, company)}
    else
      _ -> {:error, "Invalid Response"}
    end
  end

  @doc """
  Parses the html returned from lookupcompanyrevenue.com to just the company name

  ## Examples

  iex> WildPredictor.parse_name_row(~s({"td", [], [{"a", [ {"href", "/…/"}, {"class", "link"}], ["\n POPSOCKETS LLC\n "]} ]}))
  "POPSOCKETS LLC"
  """
  def parse_name_row(name_row) do
    name_row
    |> Floki.find("a")
    |> Floki.text()
    |> String.trim()
  end

  @spec to_finding([String.t()], company :: String.t()) :: Speed.Findings.Finding.t()
  def to_finding(
        [name_row, city, state, zip, rev, employee_count, _payroll, industry],
        search_name
      ) do
    %Speed.Findings.Finding{
      legal_name: parse_name_row(name_row),
      company_city: Floki.text(city),
      company_region: Floki.text(state),
      estimated_revenue: Floki.text(rev),
      company_zip_code: Floki.text(zip),
      employees: Floki.text(employee_count),
      industry: Floki.text(industry),
      search_name: search_name,
      source: source_name(),
      source_url: nil
    }
  end

  def source_name, do: "Lookup Company Revenue"
end
