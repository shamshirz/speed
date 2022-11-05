defmodule Speed.Findings.Finding do
  use Speed.Schema
  import Ecto.Changeset

  schema "findings" do
    field(:company_address, :string)
    field(:company_city, :string)
    field(:company_country, :string)
    field(:company_region, :string)
    field(:company_zip_code, :string)
    field(:description, :string)
    field(:domain, :string)
    field(:employees, :string)
    field(:estimated_revenue, :string)
    field(:industry, :string)
    field(:legal_name, :string)
    field(:naics_code, :string)
    field(:search_name, :string)
    field(:source, :string)
    field(:source_url, :string)

    timestamps()
  end

  @doc false
  def changeset(finding, attrs) do
    finding
    |> cast(attrs, [
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
    ])
    |> validate_required([
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
    ])
  end
end
