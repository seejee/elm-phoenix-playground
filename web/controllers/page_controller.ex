defmodule PhoenixAdapter.PageController do
  use PhoenixAdapter.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
