defmodule DropAlley.ChannelPartnerTest do
  use DropAlley.DataCase

  alias DropAlley.ChannelPartner

  describe "partners" do
    alias DropAlley.ChannelPartner.Partner

    @valid_attrs %{active: true, address: "some address", contact_no: "some contact_no", current_location: %{}, name: "some name", verified: true}
    @update_attrs %{active: false, address: "some updated address", contact_no: "some updated contact_no", current_location: %{}, name: "some updated name", verified: false}
    @invalid_attrs %{active: nil, address: nil, contact_no: nil, current_location: nil, name: nil, verified: nil}

    def partner_fixture(attrs \\ %{}) do
      {:ok, partner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ChannelPartner.create_partner()

      partner
    end

    test "paginate_partners/1 returns paginated list of partners" do
      for _ <- 1..20 do
        partner_fixture()
      end

      {:ok, %{partners: partners} = page} = ChannelPartner.paginate_partners(%{})

      assert length(partners) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_partners/0 returns all partners" do
      partner = partner_fixture()
      assert ChannelPartner.list_partners() == [partner]
    end

    test "get_partner!/1 returns the partner with given id" do
      partner = partner_fixture()
      assert ChannelPartner.get_partner!(partner.id) == partner
    end

    test "create_partner/1 with valid data creates a partner" do
      assert {:ok, %Partner{} = partner} = ChannelPartner.create_partner(@valid_attrs)
      assert partner.active == true
      assert partner.address == "some address"
      assert partner.contact_no == "some contact_no"
      assert partner.current_location == %{}
      assert partner.name == "some name"
      assert partner.verified == true
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ChannelPartner.create_partner(@invalid_attrs)
    end

    test "update_partner/2 with valid data updates the partner" do
      partner = partner_fixture()
      assert {:ok, partner} = ChannelPartner.update_partner(partner, @update_attrs)
      assert %Partner{} = partner
      assert partner.active == false
      assert partner.address == "some updated address"
      assert partner.contact_no == "some updated contact_no"
      assert partner.current_location == %{}
      assert partner.name == "some updated name"
      assert partner.verified == false
    end

    test "update_partner/2 with invalid data returns error changeset" do
      partner = partner_fixture()
      assert {:error, %Ecto.Changeset{}} = ChannelPartner.update_partner(partner, @invalid_attrs)
      assert partner == ChannelPartner.get_partner!(partner.id)
    end

    test "delete_partner/1 deletes the partner" do
      partner = partner_fixture()
      assert {:ok, %Partner{}} = ChannelPartner.delete_partner(partner)
      assert_raise Ecto.NoResultsError, fn -> ChannelPartner.get_partner!(partner.id) end
    end

    test "change_partner/1 returns a partner changeset" do
      partner = partner_fixture()
      assert %Ecto.Changeset{} = ChannelPartner.change_partner(partner)
    end
  end
end
