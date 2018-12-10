defmodule MangoWeb.OrderController do

  use MangoWeb, :controller

  alias Mango.Sales


  def index(conn, _params) do

    user_id = conn.assigns.current_customer.id
    #IO.puts("User ID " <> Integer.to_string(user_id) )

    orders = Sales.get_my_orders(user_id)

    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"id" => id}) do

    order = Sales.get_order_by_id(id)

    user_id = conn.assigns.current_customer.id
    case order.customer_id == user_id do
      true ->

        render(conn, "show.html", order: order)


      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(MangoWeb.ErrorView)
        |> render("404.html")


    end


  end
end