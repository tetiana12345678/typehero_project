defmodule TypeheroSerial.Formatter do
  use GenServer

  def start_link do
    IO.puts "got to serial start link"
    GenServer.start_link(__MODULE__, [], name: :serial)
  end

  def init(count) do
    count = 0
    {:ok, serial} = Serial.start_link
    Serial.open(serial, "/dev/cu.usbmodem1421")
    Serial.set_speed(serial, 9600)
    Serial.connect(serial)
    {:ok, count}
  end

  def handle_info({:elixir_serial, serial, data}, state) do
    cond do
      data =~ ~r/1/ -> Typehero.Core.finger_press(1, state)
      data =~ ~r/2/ -> IO.puts "hello finger 2"
      true -> nil
    end
    {:noreply, (state + 1)}
  end
end

#To send data to arduino to light LEDs
#Serial.send_data(serial, <<0x01, 0x02, 0x03>>)

