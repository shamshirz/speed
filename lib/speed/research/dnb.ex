defmodule Research.Dnb do
  @moduledoc """
  Wrapper around DNB data access
  It is their API, but it's unclear if we should access it directly vs. scraping the page
  Watching the network traffic, it's possible to make the same requests
  """
  @type t() :: %__MODULE__{
          company_address: String.t(),
          company_city: String.t(),
          company_country: String.t(),
          company_profile_link: String.t(),
          company_region: String.t(),
          company_zip_code: String.t(),
          country_region: String.t(),
          duns: String.t(),
          industry_name: String.t(),
          location_type: String.t(),
          primary_name: String.t(),
          url_selector: String.t()
        }

  defstruct [
    :company_address,
    :company_city,
    :company_country,
    :company_profile_link,
    :company_region,
    :company_zip_code,
    :country_region,
    :duns,
    :industry_name,
    :location_type,
    :primary_name,
    :url_selector
  ]

  @spec search(String.t()) :: {:ok, %__MODULE__{}} | {:error, String.t()}
  def search(client_name) do
    # when requesting in browser, it sends a token, but the request works without that :)
    # token=eyJwNCI6IlgzeTV3bW1DcExsMzdsUHExQ0RJSUpDTExJRkxKQ0siLCJwMiI6MiwicDMiOjMxLCJwMSI6MTY2NzA5OTYzOTcwOH0%3D
    url =
      "https://www.dnb.com/apps/dnb/servlets/CompanySearchServlet?pageNumber=1&pageSize=25&resourcePath=%2Fcontent%2Fdnb-us%2Fen%2Fhome%2Fsite-search-results%2Fjcr:content%2Fcontent-ipar-cta%2Fsinglepagesearch&returnNav=true&searchTerm=#{client_name}"

    with response <- Req.get!(url),
         most_likely_company when not is_nil(most_likely_company) <-
           hd(response.body["companies"]) do
      {:ok, build_from_response(most_likely_company)}
    else
      _ -> {:error, "Something failed"}
    end
  end

  @spec build_from_response(map()) :: %__MODULE__{}
  def build_from_response(map) do
    %__MODULE__{
      company_address: map["companyAddress"],
      company_city: map["companyCity"],
      company_country: map["companyCountry"],
      company_profile_link: map["companyProfileLink"],
      company_region: map["companyRegion"],
      company_zip_code: map["companyZipCode"],
      country_region: map["countryRegion"],
      duns: map["duns"],
      industry_name: map["industryName"],
      location_type: map["locationType"],
      primary_name: map["primaryName"],
      url_selector: map["urlSelector"]
    }
  end
end
