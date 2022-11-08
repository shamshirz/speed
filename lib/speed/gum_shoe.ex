defmodule Speed.GumShoe do
  @moduledoc """
  Tools to discover information about a company.

  ## Problem
  When considering offering services to a company, a level of due diligence is required.
  Essential non-privileged business stats must be collected to decide on services.

  ## Hypothesis
  Given a single piece of information - Company Name
  We can incrementally discover more information about that company.
  With each addition piece of information we have more ability to collect more information accurately.
  Lastly, we can aggregate results to define a confidence measure for each datum collected.

  ## Questions
  Given a company name, what is the most accurate next piece of information we can collect?
   * Primary Domain
   * Address
   * Phone Number
  What tools can we use (going directly through google seems hard)?
   * ClearBit
   * D and B
   * lookupcompanyrevenue.com
  What information is useful?
   * anything right now, even if we can't interpret it
  """

  alias Speed.Findings
  alias Speed.Findings.Finding

  require Ecto.Query

  @doc """
  Return data about the given company

  Data either comes from the cache (never expires) based on repeat search names
  or we do a fresh search and then store the results for next time.

  Fresh results should return in the order of seconds to return API data.
  Cache results should return in the magnitude of milliseconds straight from in memory.

  ## Examples

      iex> Speed.GumShoe.company("popsockets")
      %{hits: _, results: […]}
  """
  @spec company(String.t()) :: %{hits: integer(), results: [Finding.t()]}
  def company(name) do
    results =
      case Findings.list_findings(name) do
        [] ->
          name
          |> query_apis()
          |> Findings.create_findings()

        findings ->
          IO.puts("Cache hit: #{name}")
          findings
      end

    %{
      hits: Enum.count(results),
      results: results
    }
  end

  @doc """
  Query the finding APIs in parallel and return all results together
  Only returns successful results, silently hiding failures 😬
  """
  @spec query_apis(String.t()) :: [Finding.t()]
  def query_apis(name) do
    [
      fn -> Speed.Findings.Clearbit.search(name) end,
      fn -> Speed.Findings.Dnb.search(name) end,
      fn -> Speed.Findings.LookupCompanyRevenue.search(name) end
    ]
    |> Enum.map(&Task.async/1)
    |> Enum.map(&Task.await/1)
    |> Enum.filter(&match?({:ok, _}, &1))
    |> Enum.flat_map(fn
      {:ok, result} when is_list(result) -> result
      {:ok, result} -> [result]
    end)
  end
end
