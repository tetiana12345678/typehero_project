defmodule Typehero.GameServer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, pid} = Typehero.TextSupervisor.start_game("Ka")
    ref = Process.monitor(pid)
    {:ok, ref}
  end

  def handle_info({:DOWN, ref, _, _, :normal}, ref) do
    {:ok, pid} = Typehero.TextSupervisor.start_game("Ka")
    ref = Process.monitor(pid)
    {:noreply, ref}
  end

  # HOMEWORK FROM JAMES: fix it.
  # def handle_info({:DOWN, ref, _, _, reason}, ref) do
  #   {:stop, {:shutdown, reason}, ref}
  # end
end
