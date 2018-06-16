defmodule DropAlley.UserInformationTest do
  use DropAlley.DataCase

  alias DropAlley.UserInformation

  describe "addresses" do
    alias DropAlley.UserInformation.Address

    @valid_attrs %{active: true, addr: "some addr", city: "some city", contact_no: "some contact_no", pincode: "some pincode", state: "some state", street: "some street"}
    @update_attrs %{active: false, addr: "some updated addr", city: "some updated city", contact_no: "some updated contact_no", pincode: "some updated pincode", state: "some updated state", street: "some updated street"}
    @invalid_attrs %{active: nil, addr: nil, city: nil, contact_no: nil, pincode: nil, state: nil, street: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserInformation.create_address()

      address
    end

    test "paginate_addresses/1 returns paginated list of addresses" do
      for _ <- 1..20 do
        address_fixture()
      end

      {:ok, %{addresses: addresses} = page} = UserInformation.paginate_addresses(%{})

      assert length(addresses) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert UserInformation.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert UserInformation.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = UserInformation.create_address(@valid_attrs)
      assert address.active == true
      assert address.addr == "some addr"
      assert address.city == "some city"
      assert address.contact_no == "some contact_no"
      assert address.pincode == "some pincode"
      assert address.state == "some state"
      assert address.street == "some street"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserInformation.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, address} = UserInformation.update_address(address, @update_attrs)
      assert %Address{} = address
      assert address.active == false
      assert address.addr == "some updated addr"
      assert address.city == "some updated city"
      assert address.contact_no == "some updated contact_no"
      assert address.pincode == "some updated pincode"
      assert address.state == "some updated state"
      assert address.street == "some updated street"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = UserInformation.update_address(address, @invalid_attrs)
      assert address == UserInformation.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = UserInformation.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> UserInformation.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = UserInformation.change_address(address)
    end
  end
end
