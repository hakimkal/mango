defmodule Mango.CRMTest do

  use Mango.DataCase
  use Hound.Helpers
  alias Mango.CRM.Customer
  alias Mango.CRM


  test "build_customer/0 returns a customer changeset" do
    %Ecto.Changeset{data: %Customer{}} = CRM.build_customer()

  end

  test "build_customer/1 returns a customer changeset with values applied" do
    attrs = %{"name" => "John"}
    changeset = CRM.build_customer(attrs)
    assert changeset.params == attrs


  end

  test "create_customer/1 returns a new customer" do

    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }
    assert {:ok, customer} = CRM.create_customer(valid_attrs)
    assert Comeonin.Bcrypt.checkpw(valid_attrs["password"], customer.password_hash)
  end


  test "create_customer/1 returns a changeset of invalid data" do
    attrs = %{}


    assert {:error, %Ecto.Changeset{}} = CRM.create_customer(attrs)
  end

  test "get_customer_by_email/1" do
    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }
    {:ok, customer1} = CRM.create_customer(valid_attrs)
    customer2 = CRM.get_customer_by_email("john@example.com")
    assert customer1.id == customer2.id
  end


  test "get_customer_by_credentials" do

    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }
    {:ok, customer1} = CRM.create_customer(valid_attrs)
    customer2 = CRM.get_customer_by_credentials(valid_attrs)
    assert customer1.id == customer2.id
  end



end
