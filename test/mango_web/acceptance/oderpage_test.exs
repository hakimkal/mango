defmodule MangoWeb.OrderpageTest do


  use Hound.Helpers
  use MangoWeb.ConnCase
  alias Mango.CRM

  alias Mango.Sales.{Order, LineItem}
  alias Mango.Repo
  alias Mango.Catalog.Product

  hound_session()


  @valid_attrs  %{
    "name" => "John",
    "email" => "john@example.com",
    "password" => "secret",
    "residence_area" => "Area 1",
    "phone" => "1111"
  }


  test "list my orders" do


    {:ok, customer} = CRM.create_customer(@valid_attrs)

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




    navigate_to("/login")

    form = find_element(:id, "session-form")
    find_within_element(form, :name, "session[email]")
    |> fill_field("john@example.com")
    find_within_element(form, :name, "session[password]")
    |> fill_field("secret")
    find_within_element(form, :tag, "button")
    |> click


    navigate_to("/orders")

    assert current_path() == "/orders"
    page_title = find_element(:css, ".page-title")
                 |> visible_text
    assert page_title == "My Orders"


    table = find_element(:css, ".table")

    orders = find_within_element(table, :css, ".order")
    line_items = find_within_element(orders, :css, ".line-item-count")
                 |> visible_text()
    assert line_items == "1"








  end


  test "view my order details" do


    {:ok, customer} = CRM.create_customer(@valid_attrs)

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


    navigate_to("/login")

    form = find_element(:id, "session-form")
    find_within_element(form, :name, "session[email]")
    |> fill_field("john@example.com")
    find_within_element(form, :name, "session[password]")
    |> fill_field("secret")
    find_within_element(form, :tag, "button")
    |> click


    navigate_to("/orders/#{order.id}")
    assert current_path() != "/login"


    table = find_element(:css, ".table")
    page_title = find_element(:css, ".page-title") |> visible_text()
    assert page_title == "Order ##{order.id} Details"
    order_detail = find_within_element(table, :css, ".order-detail")
    product_name  = find_within_element(order_detail, :css, ".product-name") |> visible_text()
   assert  product_name == "Tomato"



  end
end