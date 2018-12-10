defmodule  MangoWeb.Acceptance.CategoryPageTest do

  use Mango.DataCase
  use Hound.Helpers

  hound_session()

  setup do

    alias Mango.Repo
    alias Mango.Catalog.Product


    ##Given ##
    # there are two products Apple and Tomato priced at 100 and 50
    #categorized under `fruits` and `vegetable` respectively
    Repo.insert(%Product{sku: "A123", name: "Tomato", price: 50, category: "vegetables", is_seasonal: false})
    Repo.insert(%Product{sku: "B232", name: "Apple", price: 100, category: "fruits", is_seasonal: true})

    :ok


  end

  test "show fruits" do
    navigate_to("/categories/fruits")

    page_title = find_element(:css, ".page-title")
                 |> visible_text()

    assert page_title == "Fruits"

    product = find_element(:class, "product")

    product_name = find_within_element(product, :class, "product-name")
                   |> visible_text()
    product_price = find_within_element(product, :class, "product-price")
                    |> visible_text()
    assert product_name == "Apple"
    assert product_price == "100"

    refute page_source() =~ "Tomato"


  end

  test "show vegetables" do

    navigate_to("/categories/vegetables")

    page_title = find_element(:css, ".page-title")
                 |> visible_text()

    assert page_title == "Vegetables"

    product = find_element(:css, ".product")

    product_name = find_within_element(product, :css, ".product-name")
                   |> visible_text()

    product_price = find_within_element(product, :css, ".product-price")
                    |> visible_text()

    assert product_name == "Tomato"
    assert product_price == "50"

    refute page_source() =~ "Apple"
  end

end
