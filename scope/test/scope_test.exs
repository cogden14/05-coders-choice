defmodule ScopeTest do
  use ExUnit.Case
  doctest Scope

  @test_topic "test channel"
  test "greets the world" do
    assert Scope.hello() == :hello_world
  end

  test "creates chat server" do
    assert Manager.start_link(@test_topic) == {:ok, :pid}
  end

  test "joins chat server" do
    assert Manager.join(@test_topic) == {:ok, @test_topic}
  end

  test "sends message to server" do
    assert Server.send_message(:peripheral, "test message") == {:noreply, "test message"}
  end

  test "lists messages" do
    assert Server.list_messages() != :null
  end

  test "lists all servers" do
    assert Manager.list_channels == {:ok, []}
  end

  test "saves server state" do
    assert ServerFarm.save_state(:server, @test_topic)
  end

  test "saves server and manager state" do
    assert ServerFarm.save_state(:all)
  end

  test "loads server state" do
    assert ServerFarm.load_state(:server, @test_topic)
  end

  test "loads server and manager state" do
    assert ServerFarm.load_state(:all)
  end

  test "creates multiple servers" do
    ServerFarm.create_server(:new, @test_topic) == {:ok, :pid}
    test_topic_2 = @test_topic + " 2"
    ServerFarm.create_server(:new, test_topic_2) == {:ok, :pid}
    assert Manager.list_channels.tuple_size == 2
  end

  test "terminates server given topic" do
    assert ServerFarm.terminate(:server, @test_topic)
  end

  test "deletes supervisor", sup do
    assert stop_supervised(sup) == :ok
  end
end
