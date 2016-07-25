defmodule TypeheroWeb.LobbyChannel do
  use TypeheroWeb.Web, :channel

  def join("games:lobby", payload, socket) do
    {:ok, socket}
  end

  def handle_in("start_game", payload, socket) do

    IO.puts("Hello we got here...")

    # {:ok, pid} =
    text = Typehero.start_game()

    push socket, "start_game", %{text: text}
    {:noreply, socket}
  end

  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
