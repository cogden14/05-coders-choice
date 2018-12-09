defmodule Messages.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :from, :string
      add :content, :string
      add :server, :string
      add :urgency, :string
      add :timestamps, :utc_datetime
    end
  end
end
