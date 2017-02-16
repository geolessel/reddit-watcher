defmodule Searcher.Repo.Migrations.AddSearches do
  use Ecto.Migration

  def change do
    create table(:searches) do
      add :subreddit, :string
      add :term, :string
      add :active, :boolean
      add :interval_minutes, :integer
      timestamps()
    end
  end
end
