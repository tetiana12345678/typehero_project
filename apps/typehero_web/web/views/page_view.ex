defmodule TypeheroWeb.PageView do
  use TypeheroWeb.Web, :view

  def pid_here do
    {:ok, pid} = Typehero.start_game("hello")
    inspect pid
  end
end
