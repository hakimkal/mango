defmodule  Mango.Catalog.Product do
#defstruct [:name, :price, :is_seasonal, :category]
use Ecto.Schema

schema "products" do
  field :image , :string
  field :name , :string
  field :price, :decimal
  field :sku , :string
  field :is_seasonal, :boolean , default: false
  field :pack_size, :string
  field :category ,:string

  timestamps()
end
end
