defmodule Mango.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mango.Sales.{Order, LineItem}


  schema "orders" do
    #field :line_items, {:array, :map}
    field :status, :string
    field :total, :decimal
    embeds_many :line_items, LineItem, on_replace: :delete


    field :comments, :string
    field :customer_id, :integer
    field :customer_name, :string
    field :email, :string
    field :residence_area, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:status, :total])
    |> cast_embed(:line_items, required: true, with: &LineItem.changeset/2)
    |> set_order_total

    |> validate_required([:status, :total])
  end

  def checkout_changeset(%Order{} = order, attrs) do
    changeset(order, attrs)
    |> cast(attrs, [:customer_id, :email, :residence_area, :customer_name, :comments])
    |> validate_required([:customer_id, :customer_name, :email, :residence_area])


  end

  defp set_order_total(changeset) do
    items = get_field(changeset, :line_items)
    total = Enum.reduce(
      items,
      Decimal.new(0),
      fn (item, acc) ->
        Decimal.add(acc, item.total)
      end
    )
    changeset
    |> put_change(:total, total)
  end
end