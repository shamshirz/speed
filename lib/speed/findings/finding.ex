defmodule Speed.Findings.Finding do
  use Speed.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          company_address: String.t(),
          company_city: String.t(),
          company_country: String.t(),
          company_region: String.t(),
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
    |> employees_to_string()
    |> validate_required([
      :search_name,
      :source
    ])
  end

  def employees_to_string(changeset) do
    employee_count = get_field(changeset, :employees)

    if is_number(employee_count) do
      put_change(changeset, :employees, Integer.to_string(employee_count))
    else
      put_change(changeset, :employees, employee_count)
    end
  end
end
