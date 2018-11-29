defmodule ScopeWeb.ChatRoomChannel do
  use ScopeWeb, :channel

  def join("chat_room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("chat_room:" <> private_room_id, payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  def handle_in("shout", payload, socket) do
    spawn(fn -> save_msg(payload) end)
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    room = String.replace_prefix(socket.topic, "chat:", "")
    Scope.Message.get_msgs()
    |> Enum.each(fn msg -> push(socket, "shout",
    %{
      name: msg.name,
      message: msg.message,
      urgent: msg.urgent,
      peripheral: msg.peripheral,
      tacton: msg.tacton
    }) end)
    {:noreply, socket}
  end
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp save_msg(msg) do
    Scope.Message.changeset(%Scope.Message{}, msg) |> Scope.Repo.insert
  end

end
