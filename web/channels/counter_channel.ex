defmodule PhoenixAdapter.CounterChannel do
  use PhoenixAdapter.Web, :channel

  def join("counter", _params, socket) do
    :timer.send_interval(2000, :tick)

    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    val = round(:rand.uniform() * 100)
    push socket, "new_counter", %{value: val}
    {:noreply, socket}
  end
end
