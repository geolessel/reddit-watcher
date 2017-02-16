defmodule Searcher.Post do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Searcher.Repo

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "posts" do
    field :title, :string
    field :reddit_id, :string
    field :html, :string
    field :text, :string
    field :url, :string
    field :hidden, :boolean, default: false
    field :posted_at, :naive_datetime
    timestamps()
  end

  def insert_new(%{"name" => reddit_id} = map) do
    case Repo.get_by(__MODULE__, %{reddit_id: reddit_id}) do
      nil -> insert(map)
      %__MODULE__{} = result -> {:existing, result}
    end
  end

  def insert(%{"title" => title,
               "name" => id,
               "selftext_html" => html,
               "selftext" => text,
               "url" => url,
               "created_utc" => posted_at}) do
    Repo.insert(%__MODULE__{title: title,
                            reddit_id: id,
                            html: html,
                            text: text,
                            url: url,
                            posted_at: DateTime.from_unix!(round(posted_at))})
  end

  def not_hidden(query \\ __MODULE__) do
    from p in query, where: p.hidden == false
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params, [:hidden])
  end
end
