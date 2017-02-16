defmodule Searcher.Repo.Migrations.AddTextToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :text, :text
    end
  end
end
