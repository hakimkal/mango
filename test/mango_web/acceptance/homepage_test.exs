defmodule MangoWeb.HomePageTest do
  use Mango.DataCase
  use Hound.Helpers

  hound_session()


  setup do

    alias Mango.Repo
    alias Mango.Catalog.Product


    ##Given ##
    # there are two products Apple and Tomato priced at 100 and 50
    #categorized under `fruits` and `vegetable` respectively
    Repo.insert %Product{sku: "A123", name: "Tomato", price: 50, category: "vegetables", is_seasonal: false}
    Repo.insert %Product{sku: "B232", name: "Apple", price: 100, category: "fruits", is_seasonal: true}
    :ok



  end
  test "presence of featured products" do

    ## GIVEN ##
    #There are two products Apple and Tomate priced at 100 and 50 respectively
    # with apple being the only seasonal product

    ##WHEN ##
    # I navigate to the homepage
    navigate_to("/")

    #Then I expect the page title to be "Seasonal Products"
    page_title = find_element(:css, ".page-title")
                 |> visible_text()
    assert page_title == "Seasonal Products"

    #And I expect Apple to be the seasonal product displayed

    product = find_element(:css, ".product")
    product_name = find_within_element(product, :css, ".product-name")
                   |> visible_text

    product_price = find_within_element(product, :css, ".product-price")
                    |> visible_text()

    assert product_name == "Apple"

    #And I expect its price to be displayed on the screen

    assert product_price == "100"

    # And I expect that Tomato is not present on  the screen
    refute page_source() =~ "Tomato"

  end
end
