defmodule Mango.CRM.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mango.CRM.{Customer,Ticket }
import Comeonin.Bcrypt , only: [hashpwsalt: 1]

  schema "customers" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string
    field :residence_area, :string
    has_many :tickets, Ticket

    timestamps()
  end

  @doc false
  def changeset(%Customer{} = customer, attrs) do
    customer
    |> cast(attrs, [:email, :name, :password, :phone, :residence_area])
    |> validate_required([:email, :name, :password, :phone, :residence_area])
    |> validate_format(:email, ~r/@/, message: "is invalid")
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do

    case changeset.valid?
      do
      true ->
        changes = changeset.changes
        put_change(changeset, :password_hash, hashpwsalt(changes.password))
      _ -> changeset
    end
  end
end