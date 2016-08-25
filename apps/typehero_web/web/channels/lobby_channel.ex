defmodule TypeheroWeb.LobbyChannel do
  use TypeheroWeb.Web, :channel

  def join("games:lobby", payload, socket) do
    {:ok, socket}
  end

  def handle_in("start_game", payload, socket) do
    text = Typehero.Core.get_text
    push socket, "start_game", %{text: text}
    {:noreply, socket}
  end

  def handle_in("key", %{"key"=> key, "count"=> count}, socket) do
    Typehero.Core.key_press(key, count, socket)
    {:noreply, socket}
  end

  def handle_in("result", payload, socket) do
    broadcast socket, "result", payload
    {:noreply, socket}
  end
end
