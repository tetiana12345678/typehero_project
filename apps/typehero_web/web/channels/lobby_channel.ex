defmodule TypeheroWeb.LobbyChannel do
  use TypeheroWeb.Web, :channel

  def join("games:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("start_game", _payload, socket) do
    text = Typehero.Core.start_game(socket)
    push socket, "start_game", %{text: text}
    {:noreply, socket}
  end

  def handle_in("key", %{"id"=> id, "key"=> key}, socket) do
    Typehero.Core.key_press(key, id)
    {:noreply, socket}
  end

  def handle_in("result", payload, socket) do
    broadcast socket, "result", payload
    {:noreply, socket}
  end
end
