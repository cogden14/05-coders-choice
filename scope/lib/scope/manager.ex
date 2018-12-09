defmodule Manager do

  @server Scope.Server
  @pubsub_name ""

  def start() do
    PubSub.start_link()
  end

  def init({name, options}) do
    {:ok, %{}}
  end

  def create_channel(topic, key \\ "") do
    if !(list_channels()
    |> Enum.member?(topic)) do
      pid = Server.start(topic, key)
      {pid, PubSub.subscribe(pid, topic)}
    else
      {:already_created, topic}
    end
  end

  def list_channels do
    PubSub.topics()
  end

  def join_channel(pid, topic) do
    if Enum.member?(PubSub.topics(), topic) do
      PubSub.subscribe(pid, topic)
    else
      PubSub.subscribe(pid, topic)
    end
  end

  def send_msg(topic, from, urgency, msg) do
    # if user |> hasAccess do
    PubSub.publish(topic, {urgency, [from: from, msg: msg]})
    # end
  end
end
