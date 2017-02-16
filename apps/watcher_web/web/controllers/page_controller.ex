defmodule WatcherWeb.PageController do
  use WatcherWeb.Web, :controller

  def index(conn, _params) do
    posts = Repo.all Searcher.Post
    render conn, "index.html", posts: posts
  end
end
