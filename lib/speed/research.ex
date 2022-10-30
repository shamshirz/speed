defmodule Research do
  @moduledoc """
  The goal of this module is to collect cools that can all incrementally discover information about a company.

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

  @doc """

  "popsockets"
  |> Research.company()
  |> IO.inspect()
  """
  @spec company(String.t()) :: {:ok, Research.Dnb.t()} | {:error, String.t()}
  def company(name) do
    Research.Dnb.search(name)
  end
end
