defmodule Speed.Case do
  use ExUnit.CaseTemplate

  setup _ do
    Mox.stub(MockSpotifyBehavior, :top, fn -> {:ok, ["Kendrick Lamar", "Bad Bunny", "J Balvin"]} end)

    Mox.stub(MockSlackClient, :post!, fn
      "https://slack.com/api/users.list" = _url, _body ->
        %{"members" => [%{"id" => "id", "name" => "miguel", "real_name" => "miguel", "is_bot" => false}]}

      _url, body ->
        body
    end)

    :ok
  end
end
