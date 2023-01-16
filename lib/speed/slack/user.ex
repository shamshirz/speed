defmodule Speed.Slack.User do
  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          real_name: String.t()
        }

  defstruct [
    :id,
    :name,
    :real_name
  ]

  @spec from_map(map()) :: Speed.Slack.User.t()
  def from_map(map) do
    %Speed.Slack.User{
      id: map["id"],
      name: map["name"],
      real_name: map["real_name"]
    }
  end
end
