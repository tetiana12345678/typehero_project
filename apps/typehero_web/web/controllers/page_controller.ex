defmodule TypeheroWeb.PageController do
  use TypeheroWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
