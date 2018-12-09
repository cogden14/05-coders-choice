defmodule Messages.Message do
  use Ecto.Schema

  schema "messages" do
    field :from, :string
    field :content, :string
    field :server, :string
    field :urgency, :string
    field :timestamps, :utc_datetime
  end
end
