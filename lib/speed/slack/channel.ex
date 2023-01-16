defmodule Speed.Slack.Channel do
  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          purpose: String.t(),
          topic: String.t()
        }

  defstruct [
    :id,
    :name,
    :purpose,
    :topic
  ]

  @spec from_map(map()) :: Speed.Slack.User.t()
  def from_map(map) do
    %__MODULE__{
      id: map["id"],
      name: map["name"],
      purpose: map["purpose"]["value"],
      topic: map["topic"]["value"]
    }
  end
end
