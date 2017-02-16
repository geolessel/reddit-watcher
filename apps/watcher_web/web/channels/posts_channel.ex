defmodule WatcherWeb.PostsChannel do
  use Phoenix.Channel

  def join("posts", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new-posts", params, socket) do
    broadcast!(socket, "new-posts", params)
    {:noreply, socket}
  end
end
