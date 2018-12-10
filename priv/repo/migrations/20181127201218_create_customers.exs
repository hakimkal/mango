defmodule Mango.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"
    create table(:customers) do
      add :email, :citext
      add :name, :string
      add :password_hash, :string
      add :phone, :string
      add :residence_area, :string

      timestamps()
    end

    create unique_index(:customers, [:email])
  end




end
