defmodule Mango.CatalogTest do
  use Mango.DataCase
  alias Mango.{Catalog, Repo}
  alias Mango.Catalog.Product

  setup do

    Repo.insert %Product{sku: "A123", name: "Tomato", price: 50, category: "vegetables", is_seasonal: false}
    Repo.insert %Product{sku: "B232", name: "Apple", price: 100, category: "fruits", is_seasonal: true}


    :ok
  end

  test "list_product/0 returns all products" do
    [p1 = %Product{}, p2 = %Product{}] = Catalog.list_products

    assert p1.name == "Tomato"

    assert p2.name == "Apple"
  end

  test "list_seasonal_products/0 return all seasonal products" do
    [product = %Product{}] = Catalog.list_seasonal_products

    assert product.name == "Apple"
  end

  test "get_category_products/1 return products of the given category" do
    [product = %Product{}] = Catalog.get_category_products("fruits")
    assert product.name == "Apple"
  end

  test "get_product" do
    [product = %Product{}] = Catalog.get_category_products("fruits")

    product2  = Catalog.get_product!(product.id)
    assert product2.name == product.name
  end
end
