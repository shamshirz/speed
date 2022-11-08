defmodule Speed.Findings.Dnb do
  @moduledoc """
  Wrapper around DNB data access
  It is their API, but it's unclear if we should access it directly vs. scraping the page
  Watching the network traffic, it's possible to make the same requests
  """

  @spec search(String.t()) :: {:ok, [Speed.Findings.Finding.t()]} | {:error, String.t()}
  def search(company) do
    base_url = "https://www.dnb.com"
    path = "/apps/dnb/servlets/CompanySearchServlet"

    params = [
      {"countryIsoAlphaTwoCode", "us"},
      {"pageNumber", 1},
      {"pageSize", 5},
      {"returnNav", true},
      {"searchTerm", company}
    ]

    with response <- Req.get!(base_url <> path, params: params),
         companies when length(companies) != 0 <-
           Enum.take(response.body["companies"], 5) do
      {:ok, Enum.map(companies, &to_finding(&1, company))}
    else
      _ -> {:error, "Something failed"}
    end
  end

  @spec to_finding(map(), String.t()) :: Speed.Findings.Finding.t()
  def to_finding(response_body, search_name) do
    %Speed.Findings.Finding{
      company_address: response_body["companyAddress"],
      company_city: response_body["companyCity"],
      company_country: response_body["companyCountry"],
      company_region: response_body["companyRegion"],
      company_zip_code: response_body["companyZipCode"],
      industry: response_body["industryName"],
      legal_name: response_body["primaryName"],
      search_name: search_name,
      source: source_name(),
      source_url: response_body["urlSelector"]
    }
  end

  def source_name, do: "D&B"
end
