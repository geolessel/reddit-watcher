defmodule Searcher.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :reddit_id, :string
      add :html, :text
      add :url, :string
      add :hidden, :boolean
      add :posted_at, :naive_datetime
      timestamps()
    end
  end
end
