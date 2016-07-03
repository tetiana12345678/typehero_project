defmodule Typehero do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Typehero.Game, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Typehero.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_game(text) do
    Typehero.TextSupervisor.start_game(text)
  end

  def check_key(pid, letter) do
    Typehero.Text.check_key(pid, letter)
  end
end
