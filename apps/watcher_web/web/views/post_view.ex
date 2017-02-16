defmodule WatcherWeb.PostView do
  use WatcherWeb.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, WatcherWeb.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, WatcherWeb.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      reddit_id: post.reddit_id,
      text: post.text,
      url: post.url,
      hidden: post.hidden,
      posted_at: post.posted_at
    }
  end
end
