defmodule Typehero.Text do
  use GenServer

  def check_key(process, letter) do
    GenServer.call(process, {:check_key, letter})
  end

  def start_link(text) do
    GenServer.start_link(__MODULE__, text)
  end

  def init(text) do
    { :ok, %{text: text}}
  end

  def handle_call({:check_key, letter}, _from, %{text: text} = state) do
    case text do
      <<^letter>> -> {:stop, :normal, :finish, state }
      <<^letter, rest::binary>> -> {:reply, :ok, %{state | text: rest}}
      _ -> {:reply, :error, state}
    end
  end
end
