defmodule DropAlley.PurchaseTest do
  use DropAlley.DataCase

  alias DropAlley.Purchase

  describe "orders" do
    alias DropAlley.Purchase.Order

    @valid_attrs %{active: true, paid: true, payment_type: "some payment_type", purchase: true, state: "some state", trial: true}
    @update_attrs %{active: false, paid: false, payment_type: "some updated payment_type", purchase: false, state: "some updated state", trial: false}
    @invalid_attrs %{active: nil, paid: nil, payment_type: nil, purchase: nil, state: nil, trial: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Purchase.create_order()

      order
    end

    test "paginate_orders/1 returns paginated list of orders" do
      for _ <- 1..20 do
        order_fixture()
      end

      {:ok, %{orders: orders} = page} = Purchase.paginate_orders(%{})

      assert length(orders) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Purchase.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Purchase.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Purchase.create_order(@valid_attrs)
      assert order.active == true
      assert order.paid == true
      assert order.payment_type == "some payment_type"
      assert order.purchase == true
      assert order.state == "some state"
      assert order.trial == true
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Purchase.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = Purchase.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.active == false
      assert order.paid == false
      assert order.payment_type == "some updated payment_type"
      assert order.purchase == false
      assert order.state == "some updated state"
      assert order.trial == false
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Purchase.update_order(order, @invalid_attrs)
      assert order == Purchase.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Purchase.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Purchase.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Purchase.change_order(order)
    end
  end

  describe "carts" do
    alias DropAlley.Purchase.OrCart

    @valid_attrs %{active: true, state: "some state"}
    @update_attrs %{active: false, state: "some updated state"}
    @invalid_attrs %{active: nil, state: nil}

    def or_cart_fixture(attrs \\ %{}) do
      {:ok, or_cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Purchase.create_or_cart()

      or_cart
    end

    test "paginate_carts/1 returns paginated list of carts" do
      for _ <- 1..20 do
        or_cart_fixture()
      end

      {:ok, %{carts: carts} = page} = Purchase.paginate_carts(%{})

      assert length(carts) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_carts/0 returns all carts" do
      or_cart = or_cart_fixture()
      assert Purchase.list_carts() == [or_cart]
    end

    test "get_or_cart!/1 returns the or_cart with given id" do
      or_cart = or_cart_fixture()
      assert Purchase.get_or_cart!(or_cart.id) == or_cart
    end

    test "create_or_cart/1 with valid data creates a or_cart" do
      assert {:ok, %OrCart{} = or_cart} = Purchase.create_or_cart(@valid_attrs)
      assert or_cart.active == true
      assert or_cart.state == "some state"
    end

    test "create_or_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Purchase.create_or_cart(@invalid_attrs)
    end

    test "update_or_cart/2 with valid data updates the or_cart" do
      or_cart = or_cart_fixture()
      assert {:ok, or_cart} = Purchase.update_or_cart(or_cart, @update_attrs)
      assert %OrCart{} = or_cart
      assert or_cart.active == false
      assert or_cart.state == "some updated state"
    end

    test "update_or_cart/2 with invalid data returns error changeset" do
      or_cart = or_cart_fixture()
      assert {:error, %Ecto.Changeset{}} = Purchase.update_or_cart(or_cart, @invalid_attrs)
      assert or_cart == Purchase.get_or_cart!(or_cart.id)
    end

    test "delete_or_cart/1 deletes the or_cart" do
      or_cart = or_cart_fixture()
      assert {:ok, %OrCart{}} = Purchase.delete_or_cart(or_cart)
      assert_raise Ecto.NoResultsError, fn -> Purchase.get_or_cart!(or_cart.id) end
    end

    test "change_or_cart/1 returns a or_cart changeset" do
      or_cart = or_cart_fixture()
      assert %Ecto.Changeset{} = Purchase.change_or_cart(or_cart)
    end
  end
end
