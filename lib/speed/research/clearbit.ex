defmodule Speed.Research.Clearbit do
  @moduledoc """
  """

  @doc """
  Auth can be bearer token, or basic auth with token as username

  Response:
  %{
    "domain" => "corvusinsurance.com",
    "logo" => "https://logo.clearbit.com/corvusinsurance.com",
    "name" => "Corvus Insurance"
  }
  """
  @spec search(String.t()) :: {:ok, Speed.Findings.Finding.t()} | {:error, String.t()}
  def search(company_name) do
    url = "https://company.clearbit.com/v1/domains/find"
    headers = [{"Authorization", "Bearer #{api_key()}"}]
    params = [{"name", company_name}]
    response = Req.get!(url, headers: headers, params: params)
    IO.inspect(response)

    case response.body do
      %{"domain" => domain} -> search_domain(domain)
      _ -> {:error, "Invalid Response"}
    end
  end

  @doc """
  Example: https://company.clearbit.com/v2/companies/find?domain=corvusinsurance.com'

  %{
   "category" => %{
     "industry" => "Internet Software & Services",
     "industryGroup" => "Software & Services",
     "naicsCode" => "51",
     "sector" => "Information Technology",
     "sicCode" => "48",
     "subIndustry" => "Internet Software & Services"
   },
   "crunchbase" => %{"handle" => nil},
   "description" => "Corvus empowers brokers to predict and prevent complex risks. We offer Smart Commercial Insurance policies paired with data-driven risk management tools.",
   "domain" => "corvusinsurance.com",
   "domainAliases" => ["wingmaninsurance.com", "tarianuw.com"],
   "emailProvider" => false,
   "facebook" => %{"handle" => nil, "likes" => nil},
   "foundedYear" => 2017,
   "geo" => %{
     "city" => "Boston",
     "country" => "United States",
     "countryCode" => "US",
     "lat" => 42.3538104,
     "lng" => -71.057391,
     "postalCode" => "02110",
     "state" => "Massachusetts",
     "stateCode" => "MA",
     "streetAddress" => "100 Summer Street",
     "streetName" => "Summer Street",
     "streetNumber" => "100",
     "subPremise" => nil
   },
   "id" => "2fc2c794-3a70-4e90-939d-984e84c8a21b",
   "identifiers" => %{"usEIN" => nil},
   "indexedAt" => "2022-10-02T07:33:05.935Z",
   "legalName" => "Corvus Insurance Holdings Inc",
   "linkedin" => %{"handle" => "company/corvusinsurance"},
   "location" => "100 Summer Street, 100 Summer St, Boston, MA 02110, USA",
   "logo" => "https://logo.clearbit.com/corvusinsurance.com",
   "metrics" => %{
     "alexaGlobalRank" => 621503,
     "alexaUsRank" => 201221,
     "annualRevenue" => nil,
     "employees" => 270,
     "employeesRange" => "251-1K",
     "estimatedAnnualRevenue" => "$10M-$50M",
     "fiscalYearEnd" => 12,
     "marketCap" => nil,
     "raised" => 160800000
   },
   "name" => "Corvus Insurance",
   "parent" => %{"domain" => nil},
   "phone" => "+1 857-259-3995",
   "site" => %{
     "emailAddresses" => ["claims@corvusinsurance.com",
      "info@corvusinsurance.com", "legal@corvusinsurance.com",
      "gwhite@corvusinsurance.com", "mwaller@corvusinsurance.com",
      "jberry@corvusinsurance.com", "ewright@corvusinsurance.com",
      "lhowden@corvusinsurance.com", "gdavies@corvusinsurance.com",
      "jthomas@corvusinsurance.com"],
     "phoneNumbers" => ["+1 857-259-3995", "+49 69 2443758", "+44 7402 571454",
      "+44 7780 057879", "+44 7970 007363", "+44 7826 621498"]
   },
   "tags" => ["Information Technology & Services", "Technology", "Insurance",
    "B2B", "Enterprise", "SAAS"],
   "tech" => ["google_apps", "aws_route_53", "wistia", "cloud_flare",
    "sendgrid", "google_analytics", "hotjar", "amazon_ses",
    "google_tag_manager", "hubspot", "piwik", "sixsense", "conversio",
    "quickbooks", "salesforce", "mysql"],
   "techCategories" => ["productivity", "dns", "image_video_services",
    "email_delivery_service", "analytics", "website_optimization",
    "tag_management", "marketing_automation", "account_based_marketing",
    "accounting_and_finance", "crm", "database"],
   "ticker" => nil,
   "timeZone" => "America/New_York",
   "twitter" => %{
     "avatar" => "https://pbs.twimg.com/profile_images/1562429442764701696/DTUXvcqU_normal.jpg",
     "bio" => "Empowering commercial insurance brokers and policyholders to better predict and prevent loss through AI-driven Smart Commercial Insurance® policies",
     "followers" => 545,
     "following" => 398,
     "handle" => "CorvusInsurance",
     "id" => "832266916039389185",
     "location" => "Boston, MA",
     "site" => "https://t.co/jB5S1z57zn"
   },
   "type" => "private",
   "ultimateParent" => %{"domain" => nil},
   "utcOffset" => -4
  }}
  """
  @spec search_domain(String.t()) :: {:ok, Speed.Findings.Finding.t()} | {:error, String.t()}
  def search_domain(domain_without_protocol) do
    base_url = "https://company.clearbit.com/v2/companies/find"
    params = [{"domain", domain_without_protocol}]
    headers = [{"Authorization", "Bearer #{api_key()}"}]
    response = Req.get!(base_url, headers: headers, params: params)

    # IO.inspect(response)

    case response.body do
      body when is_map(body) -> {:ok, to_finding(body)}
      _ -> {:error, "Invalid Response"}
    end
  end

  @spec to_finding(map()) :: Speed.Findings.Finding.t()
  def to_finding(response_body) do
    %Speed.Findings.Finding{
      company_address: response_body["geo"]["streetAddress"],
      company_city: response_body["geo"]["city"],
      company_country: response_body["geo"]["country"],
      company_region: response_body["geo"]["state"],
      company_zip_code: response_body["geo"]["postalCode"],
      domain: response_body["domain"],
      employees: response_body["metrics"]["employees"],
      estimated_revenue: response_body["metrics"]["estimatedAnnualRevenue"],
      industry: response_body["category"]["industry"],
      legal_name: response_body["legalName"],
      naics_code: response_body["category"]["naicsCode"],
      # Maybe this should be the name that the function above accepted
      search_name: response_body["name"],
      source: source_name(),
      source_url: nil
    }
  end

  def source_name, do: "Clearbit"

  def api_key, do: Application.get_env(:speed, __MODULE__)[:api_key]
end
