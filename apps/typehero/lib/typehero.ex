defmodule Typehero do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # supervisor(Typehero.Game, [])
      supervisor(Typehero.TextSupervisor, []),
      #TODO look at the best supervision strategy for current problem
      worker(Typehero.EventHandler, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  def start_game do
    Typehero.TextSupervisor.start_game
  end

  def key_press(pid, letter, count) do
    Typehero.Text.key_press(pid, letter, count)
  end

  def finger_press(pid, letter, count) do
    Typehero.Text.finger_press(pid, letter, count)
  end

  def get_state(pid) do
    Typehero.Text.get_state(pid)
  end
end
