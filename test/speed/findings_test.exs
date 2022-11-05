defmodule Speed.FindingsTest do
  use Speed.DataCase, async: true

  alias Speed.Findings

  describe "findings" do
    alias Speed.Findings.Finding

    import Speed.FindingsFixtures

    @invalid_attrs %{
      company_address: nil,
      company_city: nil,
      company_country: nil,
      company_region: nil,
      company_zip_code: nil,
      description: nil,
      domain: nil,
      employees: nil,
      estimated_revenue: nil,
      industry: nil,
      legal_name: nil,
      naics_code: nil,
      search_name: nil,
      source: nil,
      source_url: nil
    }

    test "list_findings/0 returns all findings" do
      finding = finding_fixture()
      assert Findings.list_findings() == [finding]
    end

    test "get_finding!/1 returns the finding with given id" do
      finding = finding_fixture()
      assert Findings.get_finding!(finding.id) == finding
    end

    test "create_finding/1 with valid data creates a finding" do
      valid_attrs = %{
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
      }

      assert {:ok, %Finding{} = finding} = Findings.create_finding(valid_attrs)
      assert finding.company_address == "some company_address"
      assert finding.company_city == "some company_city"
      assert finding.company_country == "some company_country"
      assert finding.company_region == "some company_region"
      assert finding.company_zip_code == "some company_zip_code"
      assert finding.description == "some description"
      assert finding.domain == "some domain"
      assert finding.employees == "some employees"
      assert finding.estimated_revenue == "some estimated_revenue"
      assert finding.industry == "some industry"
      assert finding.legal_name == "some legal_name"
      assert finding.naics_code == "some naics_code"
      assert finding.search_name == "some search_name"
      assert finding.source == "some source"
      assert finding.source_url == "some source_url"
    end

    test "create_finding/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Findings.create_finding(@invalid_attrs)
    end

    test "update_finding/2 with valid data updates the finding" do
      finding = finding_fixture()

      update_attrs = %{
        company_address: "some updated company_address",
        company_city: "some updated company_city",
        company_country: "some updated company_country",
        company_region: "some updated company_region",
        company_zip_code: "some updated company_zip_code",
        description: "some updated description",
        domain: "some updated domain",
        employees: "some updated employees",
        estimated_revenue: "some updated estimated_revenue",
        industry: "some updated industry",
        legal_name: "some updated legal_name",
        naics_code: "some updated naics_code",
        search_name: "some updated search_name",
        source: "some updated source",
        source_url: "some updated source_url"
      }

      assert {:ok, %Finding{} = finding} = Findings.update_finding(finding, update_attrs)
      assert finding.company_address == "some updated company_address"
      assert finding.company_city == "some updated company_city"
      assert finding.company_country == "some updated company_country"
      assert finding.company_region == "some updated company_region"
      assert finding.company_zip_code == "some updated company_zip_code"
      assert finding.description == "some updated description"
      assert finding.domain == "some updated domain"
      assert finding.employees == "some updated employees"
      assert finding.estimated_revenue == "some updated estimated_revenue"
      assert finding.industry == "some updated industry"
      assert finding.legal_name == "some updated legal_name"
      assert finding.naics_code == "some updated naics_code"
      assert finding.search_name == "some updated search_name"
      assert finding.source == "some updated source"
      assert finding.source_url == "some updated source_url"
    end

    test "update_finding/2 with invalid data returns error changeset" do
      finding = finding_fixture()
      assert {:error, %Ecto.Changeset{}} = Findings.update_finding(finding, @invalid_attrs)
      assert finding == Findings.get_finding!(finding.id)
    end

    test "delete_finding/1 deletes the finding" do
      finding = finding_fixture()
      assert {:ok, %Finding{}} = Findings.delete_finding(finding)
      assert_raise Ecto.NoResultsError, fn -> Findings.get_finding!(finding.id) end
    end

    test "change_finding/1 returns a finding changeset" do
      finding = finding_fixture()
      assert %Ecto.Changeset{} = Findings.change_finding(finding)
    end
  end
end
