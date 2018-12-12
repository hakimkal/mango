defmodule Mango.CRM do
  alias Mango.CRM.Customer
  alias Mango.Repo
  #09553665

  def build_customer(attrs \\ %{}) do

    %Customer{}
    |> Customer.changeset(attrs)
  end

  def create_customer(attrs) do
    attrs
    |> build_customer
    |> Repo.insert

  end

  def get_customer_by_email(email) do
    Repo.get_by(Customer, email: email)

  end

  def get_customer_by_id(id) do
    Repo.get_by(Customer, id: id)
  end
  def get_customer_by_credentials(%{"email" => email, "password" => pass}) do

    customer = get_customer_by_email(email)
    cond do
      customer && Comeonin.Bcrypt.checkpw(pass, customer.password_hash) -> customer
      true -> :error
    end
  end

  alias Mango.CRM.Ticket

  def list_customer_tickets(%Customer{} = customer) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.all(Ticket)
  end


  def get_customer_ticket!(%Customer{} = customer, id) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.get!(Ticket, id)

  end


  def build_customer_ticket(%Customer{} = customer, attrs \\ %{}) do

    Ecto.build_assoc(customer, :tickets, %{status: "New"})
    |> Ticket.changeset(attrs)

  end


  def create_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    build_customer_ticket(customer, attrs)
    |> Repo.insert()

  end

end
