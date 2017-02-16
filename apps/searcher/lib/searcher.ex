defmodule Searcher do
  @moduledoc """
  Documentation for Searcher.
  """

  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://reddit.com/r"
  plug Tesla.Middleware.JSON

  def search(subreddit, term, limit \\ 10) do
    get(
      subreddit <>
      "/search.json?q=" <> term <>
      "&limit=" <> Integer.to_string(limit) <>
      "&sort=new&restrict_sr=on&raw_json=1"
    )
    |> process_response()
  end

  def fetch_titles do
    search("mechmarket", "ergodox", 2)
    |> Map.get(:body)
    |> titles()
  end

  def titles(body) do
    body
    |> deep_get(["data", "children"])
    |> Enum.map(&deep_get(&1, ["data", "title"]))
  end

  def deep_get(map, [terms]), do: Map.get(map, terms, nil)
  def deep_get(map, [head | tail]) do
    Map.get(map, head, %{})
    |> deep_get(tail)
  end

  defp process_response(%{status: status} = response) when status in 200..299, do: {:ok, response}
  defp process_response(response), do: {:error, response}

#    %Tesla.Env{__client__: nil, __module__: Searcher,
# body: %{"data" => %{"after" => "t3_5ti532", "before" => nil,
#     "children" => [%{"data" => %{"visited" => false, "approved_by" => nil,
#          "title" => "[US-CA][H] ErgoDox Left GamePad, Granite Extras [W] PayPal",
#          "created" => 1486882874.0, "quarantine" => false,
#          "domain" => "self.mechmarket", "saved" => false, "mod_reports" => [],
#          "locked" => false, "suggested_sort" => "new", "likes" => nil,
#          "permalink" => "/r/mechmarket/comments/5ti532/uscah_ergodox_left_gamepad_granite_extras_w_paypal/?ref=search_posts",
#          "created_utc" => 1486854074.0, "secure_media_embed" => %{},
#          "contest_mode" => false, "media_embed" => %{}, "gilded" => 0,
#          "secure_media" => nil, "id" => "5ti532",
#          "author_flair_css_class" => "i-76", "user_reports" => [], "ups" => 3,
#          "score" => 3, "thumbnail" => "", "subreddit_id" => "t5_2vgng",
#          "archived" => false, "link_flair_css_class" => "selling",
#          "hide_score" => false, "name" => "t3_5ti532", "over_18" => false,
#          "author" => "SkimZor", "author_flair_text" => nil, "is_self" => true,
#          "banned_by" => nil, "hidden" => false,
#          "url" => "https://www.reddit.com/r/mechmarket/comments/5ti532/uscah_ergodox_left_gamepad_granite_extras_w_paypal/",
#          "distinguished" => nil, "num_reports" => nil,
#          "link_flair_text" => "Selling", "report_reasons" => nil,
#          "clicked" => false, "media" => nil, ...}, "kind" => "t3"}],
#     "facets" => %{}, "modhash" => ""}, "kind" => "Listing"},
# headers: %{"accept-ranges" => "bytes", "access-control-allow-origin" => "*",
#   "access-control-expose-headers" => "X-Reddit-Tracking, X-Moose",
#   "cache-control" => "max-age=0, must-revalidate",
#   "connection" => "keep-alive", "content-length" => "3918",
#   "content-type" => "application/json; charset=UTF-8",
#   "date" => "Sun, 12 Feb 2017 05:05:03 GMT", "fastly-restarts" => "1",
#   "server" => "snooserv",
#   "set-cookie" => "loidcreated=1486875892000; Domain=reddit.com; Max-Age=63071999; Path=/;  secure",
#   "strict-transport-security" => "max-age=15552000; includeSubDomains; preload",
#   "vary" => "accept-encoding", "via" => "1.1 varnish", "x-cache" => "MISS",
#   "x-cache-hits" => "0", "x-content-type-options" => "nosniff",
#   "x-frame-options" => "SAMEORIGIN", "x-moose" => "majestic",
#   "x-reddit-tracking" => "https://pixel.redditmedia.com/pixel/of_destiny.png?v=7vFznoDHwrBKuxJsIn9xyL6brjY230jwR1iQUKdLQKTBIcf4CcpPtK8%2BwXoMJ2IjGYqrqmvcWHc%3D",
#   "x-served-by" => "cache-dfw1834-DFW",
#   "x-timer" => "S1486875892.531475,VS0,VE10898",
#   "x-ua-compatible" => "IE=edge", "x-xss-protection" => "1; mode=block"},
# method: :get, opts: [], query: [], status: 200,
# url: "https://reddit.com/r/mechmarket/search.json?q=ergodox&limit=1&sort=new&restrict_sr=on&raw_json=1"}

end
