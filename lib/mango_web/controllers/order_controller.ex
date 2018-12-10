defmodule MangoWeb.OrderController do

  use MangoWeb, :controller

  alias Mango.Sales


  def index(conn, _params) do

    user_id  =  conn.assigns.current_customer.id
    #IO.puts("User ID " <> Integer.to_string(user_id) )

    orders =  Sales.get_my_orders(user_id)

    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"id" => id}) do

    order = Sales.get_my_orders(id)

    render(conn, "show.html",order: order)

  end
end