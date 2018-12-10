defmodule Mango.SalesTest do
  use Mango.DataCase
  alias Mango.{CRM, Sales, Repo}
  alias Mango.Sales.{Order, LineItem}
  alias Mango.Catalog.Product


  test "add_to_cart/2" do
    product = %Product{
                name: "Tomato",
                pack_size: "1 kg",
                price: 55,
                sku: "A123",
                is_seasonal: false,
                category: "vegetables"
              }
              |> Repo.insert!
    cart = Sales.create_cart
    {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => product.id, "quantity" => "2"})
    assert [line_item] = cart.line_items
    assert line_item.product_id == product.id
    assert line_item.product_name == "Tomato"
    assert line_item.pack_size == "1 kg"
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(product.price)

    assert line_item.total == Decimal.mult(Decimal.new(product.price), Decimal.new(2))
  end


  test "create_cart" do
    assert %Order{status: "In Cart"} = Sales.create_cart
  end

  test "get_cart/1" do
    cart1 = Sales.create_cart
    cart2 = Sales.get_cart(cart1.id)
    assert cart1.id == cart2.id
  end

  test "list_my_orders/1" do


    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }
    {:ok, customer} = CRM.create_customer(valid_attrs)

    product = %Product{
                name: "Tomato",
                pack_size: "1 kg",
                price: 55,
                sku: "A123",
                is_seasonal: false,
                category: "vegetables"
              }
              |> Repo.insert!

    line_items = [
      %LineItem{
        product_id: product.id,
        product_name: product.name,
        pack_size: product.pack_size,
        quantity: 3,
        unit_price: product.price,
        total: 3 * product.price
      }
    ]

    %Order{
      status: "Confirmed",
      total: 10,
      customer_id: customer.id,
      email: customer.email,
      customer_name: customer.name,
      line_items: line_items
    }
    |> Repo.insert!



    [order | _rest  ]  = Sales.get_my_orders(customer.id)

    assert order.customer_id == customer.id
    assert Enum.count(order.line_items) == 1

  end

  test "get_order_by_id" do

    valid_attrs = %{
      "name" => "John",
      "email" => "john@example.com",
      "password" => "secret",
      "residence_area" => "Area 1",
      "phone" => "1111"
    }
    {:ok, customer} = CRM.create_customer(valid_attrs)

    product = %Product{
                name: "Tomato",
                pack_size: "1 kg",
                price: 55,
                sku: "A123",
                is_seasonal: false,
                category: "vegetables"
              }
              |> Repo.insert!

    line_items = [
      %LineItem{
        product_id: product.id,
        product_name: product.name,
        pack_size: product.pack_size,
        quantity: 3,
        unit_price: product.price,
        total: 3 * product.price
      }
    ]

    order = %Order{
      status: "Confirmed",
      total: 10,
      customer_id: customer.id,
      email: customer.email,
      customer_name: customer.name,
      line_items: line_items
    }
    |> Repo.insert!


    the_order = Sales.get_order_by_id(order.id)

    assert the_order.id == order.id

  end
end

