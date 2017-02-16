defmodule Searcher.Search do
  use Ecto.Schema
  import Ecto.Changeset

  schema "searches" do
    field :subreddit, :string
    field :term, :string
    field :active, :boolean
    field :interval_minutes, :integer
    timestamps()
  end

  def changeset(search, params \\ %{}) do
    search
    |> cast(params, [:subreddit, :term, :active, :interval_minutes])
  end
end
