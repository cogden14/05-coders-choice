defmodule User do
  @servers

  defmodule Read do
    %{}
  end

  def request(:all, topic) do
    {:ok, :messges}
  end

  def request(:unread, read, topic) do
    {:error, :notimplemented}
  end

  # Adjust the priority of the channel [:active, :quiet]
  def set_priority(priority, server) do
    {:error, :not_implemented, priority}
  end

  def view_msgs(server) do
    {:error, :not_implemented, server}
  end

  # Request to join a server, optional key to grant access
  def join(server, _key) do
    @servers = @servers ++ Server.start_link(server, _key)
  end
end
