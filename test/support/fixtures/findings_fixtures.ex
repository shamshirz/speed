defmodule Speed.FindingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Speed.Findings` context.
  """

  @doc """
  Generate a finding.
  """
  def finding_fixture(attrs \\ %{}) do
    {:ok, finding} =
      attrs
      |> Enum.into(%{
        company_address: "some company_address",
        company_city: "some company_city",
        company_country: "some company_country",
        company_region: "some company_region",
        company_zip_code: "some company_zip_code",
        description: "some description",
        domain: "some domain",
        employees: "some employees",
        estimated_revenue: "some estimated_revenue",
        industry: "some industry",
        legal_name: "some legal_name",
        naics_code: "some naics_code",
        search_name: "some search_name",
        source: "some source",
        source_url: "some source_url"
      })
      |> Speed.Findings.create_finding()

    finding
  end
end
