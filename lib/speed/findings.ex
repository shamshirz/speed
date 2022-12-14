defmodule Speed.Findings do
  @moduledoc """
  The Findings context.
  """

  import Ecto.Query, warn: false
  alias Speed.Repo

  alias Speed.Findings.Finding

  @doc """
  Returns the list of findings.

  ## Examples

      iex> list_findings()
      [%Finding{}, ...]

  """
  def list_findings do
    Repo.all(Finding)
  end

  @doc """
  Returns findings where search_name matches

  ## Examples

      iex> list_findings("crazyt3xt")
      []
  """
  def list_findings(search_name) do
    Finding
    |> Ecto.Query.where(search_name: ^search_name)
    |> Speed.Repo.all()
  end

  @doc """
  Gets a single finding.

  Raises `Ecto.NoResultsError` if the Finding does not exist.

  ## Examples

      iex> get_finding!(123)
      %Finding{}

      iex> get_finding!(456)
      ** (Ecto.NoResultsError)

  """
  def get_finding!(id), do: Repo.get!(Finding, id)

  @doc """
  Creates a finding.

  ## Examples

      iex> create_finding(%{field: value})
      {:ok, %Finding{}}

      iex> create_finding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_finding(attrs \\ %{}) do
    %Finding{}
    |> Finding.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Insert all of the results 1 at a time

  _note_
  Could be an insert_all and handle upsert (we _should_ only insert if we didn't find any)
  """
  @spec create_findings([Finding.t()]) :: [Finding.t()]
  def create_findings(findings) do
    for finding <- findings, do: finding |> Finding.changeset(%{}) |> Repo.insert!()
  end

  @doc """
  Updates a finding.

  ## Examples

      iex> update_finding(finding, %{field: new_value})
      {:ok, %Finding{}}

      iex> update_finding(finding, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_finding(%Finding{} = finding, attrs) do
    finding
    |> Finding.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a finding.

  ## Examples

      iex> delete_finding(finding)
      {:ok, %Finding{}}

      iex> delete_finding(finding)
      {:error, %Ecto.Changeset{}}

  """
  def delete_finding(%Finding{} = finding) do
    Repo.delete(finding)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking finding changes.

  ## Examples

      iex> change_finding(finding)
      %Ecto.Changeset{data: %Finding{}}

  """
  def change_finding(%Finding{} = finding, attrs \\ %{}) do
    Finding.changeset(finding, attrs)
  end
end
