defmodule Mango.Catalog do
alias Mango.Catalog.Product
alias Mango.Repo

  def list_products do
   Product
   |> Repo.all
  end

  def get_product!(product_id) do

    Repo.get_by(Product, id:  product_id)
end

  def list_seasonal_products do
    list_products()
    |> Enum.filter(fn(product) -> product.is_seasonal == true end )
  end


  def get_category_products(name) do
    list_products()
    |> Enum.filter(fn(product) -> product.category == name end)
  end
end
