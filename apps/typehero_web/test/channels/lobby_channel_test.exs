defmodule TypeheroWeb.LobbyChannelTest do
  use TypeheroWeb.ChannelCase

  alias TypeheroWeb.LobbyChannel

  # setup do
  #   {:ok, _, socket} =
  #     socket
  #     |> subscribe_and_join(LobbyChannel, "games:lobby")

  #   {:ok, socket: socket}
  # end

  # test "key replies with status noreply", %{socket: socket} do
  #   IO.puts "socket"
  #   IO.inspect socket
  #   ref = push socket, "key", %{"key"=> "h", "count"=> 1}
  #   assert_reply ref, :noreply, %{"key"=> "h", "count"=> 1}
  # end

  # test "shout broadcasts to games:lobby", %{socket: socket} do
  #   push socket, "shout", %{"hello" => "all"}
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
