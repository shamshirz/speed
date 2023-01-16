defmodule Speed.SlackTest do
  use Speed.Case, async: true

  test "get users" do
    assert Speed.Slack.list_users() == [%Speed.Slack.User{id: "id", name: "miguel", real_name: "miguel"}]
  end

  test "send_message doesn't really send a message" do
    assert Speed.Slack.ping_me() == {:form, [icon_emoji: ":sylver-studios:", username: "SpeedBot", text: "Ping!", channel: "id"]}
  end
end
