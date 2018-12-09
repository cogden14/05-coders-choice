defmodule ServerFarm do
  use DynamicSupervisor

  @servers []

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def save_state(:all) do
    {:ok, :all}
  end

  def save_state(:server, topic) do
    {:ok, topic}
  end

  def load_state(:all) do
    {:noreply, :all}
  end

  def load_state(:server, topic) do
    {:noreply, topic}
  end

  def terminate(:server, topic) do
    {:error, :not_implemented}
  end

  def terminate(:all) do
    {:error, :not_implemented}
  end

  def start_child(foo, bar, baz) do
    spec = {Server, foo: foo, bar: bar, baz: baz}
    DynamicSupervisor.start_child(__MODULE__, foo)
  end

  @impl true
  def init(initial_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_many,
      extra_arguments: [initial_arg]
    )
  end

end
