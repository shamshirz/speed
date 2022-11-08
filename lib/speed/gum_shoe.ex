defmodule Speed.GumShoe do
  @moduledoc """
  The goal of this module is to collect tools that can all incrementally discover information about a company.

  ## Problem
  When considering offering services to a company, a level of due diligence is required.
  After that, some essential business stats must be collected to decide on what to offer (thus impacting rates).

  ## Hypothesis
  Given a single piece of information - Company Name
  We can incrementally discover more information about that company.
  With each addition piece of information we have more ability to collect more information accurately.

  ## Questions
  Given a company name, what is the most accurate next piece of information we can collect?
   * Primary Domain
   * Address
   * Phone Number
  What tools can we use (going directly through google seems hard)?
   * ?
  What information is useful?
   * Company Data and websites that claim to have information on them even if we can't parse it
  """

  alias Speed.Repo
  alias Speed.Findings.Finding

  require Ecto.Query

  @doc """
  "popsockets"
  |> Research.company()
  |> IO.inspect()
  """
  @spec company(String.t()) :: %{hits: integer(), results: [Finding.t()]}
  def company(name) do
    results =
      case check_cache(name) |> IO.inspect(label: "check cache response") do
        {:error, _} ->
          name
          |> query_apis()
          |> update_cache()

        {:ok, cache_hit} ->
          IO.puts("Cache hit: #{name}")
          cache_hit
      end

    %{
      hits: Enum.count(results),
      results: results
    }
  end

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
    # |> IO.inspect()
    |> Enum.flat_map(fn
      {:ok, result} when is_list(result) -> result
      {:ok, result} -> [result]
    end)
  end

  @spec check_cache(String.t()) :: {:ok, [Speed.Finding.t()]} | {:error, :not_found}
  def check_cache(search_name) do
    case Finding
         |> Ecto.Query.where(search_name: ^search_name)
         |> Speed.Repo.all() do
      [] -> {:error, :not_found}
      results -> {:ok, results}
    end
  end

  @doc """
  Insert all of the results 1 at a time

  _note_
  Could be an insert_all and handle upsert (we _should_ only insert if we didn't find any)
  """
  @spec update_cache([Finding.t()]) :: [Finding.t()]
  def update_cache(results) do
    results
    |> Enum.map(&Finding.changeset(&1, %{}))
    |> IO.inspect(label: "cache update response")
    |> Enum.each(&Repo.insert/1)
    |> IO.inspect(label: "cache update response")

    results
  end

  def sample_test do
    for company_name <- Speed.Findings.Data.sample(), reduce: 0 do
      acc ->
        with result <- company(company_name) do
          IO.puts("#{company_name} Hits: #{result.hits}")
          Process.sleep(5000)
          acc + result.hits
        else
          error ->
            IO.inspect(error, label: "error")
            acc
        end
    end
  end

  @doc """
  Use the text similarity between the client name and the domain to sort domains by similarity.
  Unused rn
  """
  @spec sort_domains_by_name_similarity(String.t(), [String.t()]) :: [String.t()]
  def sort_domains_by_name_similarity(client_name, domains) do
    domains
    |> Enum.map(fn domain -> {domain, String.jaro_distance(client_name, domain)} end)
    |> Enum.sort(fn {_, one_distance}, {_, two_distance} ->
      one_distance > two_distance
    end)
    |> Enum.map(&elem(&1, 0))
  end
end
