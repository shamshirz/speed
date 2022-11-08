defmodule Speed.Repo.Migrations.CreateFindings do
  use Ecto.Migration

  def change do
    create table(:findings) do
      add(:company_address, :string)
      add(:company_city, :string)
      add(:company_country, :string)
      add(:company_region, :string)
      add(:company_zip_code, :string)
      add(:description, :string)
      add(:domain, :string)
      add(:employees, :string)
      add(:estimated_revenue, :string)
      add(:industry, :string)
      add(:legal_name, :string)
      add(:naics_code, :string)
      add(:search_name, :string)
      add(:source, :string)
      add(:source_url, :string)

      timestamps()
    end

    create(
      index(:findings, [:search_name], comment: "Index search_name to use as cache lookup column")
    )
  end
end
