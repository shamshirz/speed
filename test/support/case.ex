defmodule Speed.Case do
  use ExUnit.CaseTemplate

  setup _ do
    Mox.stub(MockSpotifyBehavior, :top, fn -> {:ok, ["Kendrick Lamar", "Bad Bunny", "J Balvin"]} end)
    :ok
  end
end
