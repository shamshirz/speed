defmodule Speed.Research.Finding do
  @moduledoc """
  Common data structure for research findings
  """

  @type t() :: %__MODULE__{
          company_address: String.t(),
          company_city: String.t(),
          company_country: String.t(),
          company_region: state :: String.t(),
          company_zip_code: String.t(),
          description: String.t(),
          domain: String.t(),
          employees: String.t(),
          estimated_revenue: String.t(),
          industry: String.t(),
          legal_name: String.t(),
          naics_code: String.t(),
          search_name: String.t(),
          source: String.t(),
          source_url: String.t()
        }

  defstruct [
    :company_address,
    :company_city,
    :company_country,
    :company_region,
    :company_zip_code,
    :description,
    :domain,
    :employees,
    :estimated_revenue,
    :industry,
    :legal_name,
    :naics_code,
    :search_name,
    :source,
    :source_url
  ]
end
