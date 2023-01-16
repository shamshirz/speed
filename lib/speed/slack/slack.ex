defmodule Speed.Slack do
  @moduledoc """
  The Slack module is responsible for sending messages to Slack.

  Not using the RealTimeMessage functionality.
  """

  require Logger

  defp default_dm, do: "miguel"

  @spec list_users() :: [Speed.Slack.User.t()]
  def list_users do
    Slack.Web.Users.list()
    |> Map.get("members")
    |> Enum.filter(&(not &1["is_bot"]))
    |> Enum.map(&Speed.Slack.User.from_map/1)
  end

  @doc "List all 'channel-like' things in slack. `Channels.list` is deprecated."
  @spec list_channels() :: [Speed.Slack.Channel.t()]
  def list_channels do
    Slack.Web.Conversations.list()
    |> Map.get("channels")
    |> Enum.filter(&(not &1["is_archived"]))
    |> Enum.map(&Speed.Slack.Channel.from_map/1)
  end

  @doc """
  Sends a message to Slack.
  """
  @spec send_message(String.t(), String.t()) :: :ok | {:error, any()}
  def send_message(channel, message) do
    default_params = %{
      icon_emoji: ":sylver-studios:",
      username: "SpeedBot"
    }

    Slack.Web.Chat.post_message(channel, message, default_params)
  end

  @spec ping_me :: map() | (slack_lib_error :: any())
  def ping_me(message \\ "Ping!") do
    list_users()
    |> Enum.find(fn user -> user.name == default_dm() end)
    |> Map.get(:id)
    |> send_message(message)
  end
end
