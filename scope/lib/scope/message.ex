defmodule Scope.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2, distinct: 3]

  schema "messages" do
    field :chatroom, :string
    field :message, :string
    field :urgency, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:username, :message, :urgency, :chatroom])
    |> validate_required([:username, :message, :urgency, :chatroom])
  end

  def get_msgs(limit \\ 20) do
    Scope.Repo.all(Scope.Message, limit: limit)
  end

  # get all channels available to a user
  def get_channels(username \\ '*') do
    query = from u in Scope.Message,
              select: u.chatroom

    Scope.Repo.all(query)
  end
end
