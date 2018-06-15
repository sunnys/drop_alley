defmodule DropAlley.AccountTest do
  use DropAlley.DataCase

  alias DropAlley.Account

  describe "users" do
    alias DropAlley.Account.User

    @valid_attrs %{confirmation_sent_at: "2010-04-17 14:00:00.000000Z", confirmation_token: "some confirmation_token", confirmed_at: "2010-04-17 14:00:00.000000Z", current_sign_in_at: "2010-04-17 14:00:00.000000Z", current_sign_in_ip: "some current_sign_in_ip", email: "some email", failed_attempts: 42, last_sign_in_at: "2010-04-17 14:00:00.000000Z", last_sign_in_ip: "some last_sign_in_ip", locked_at: "2010-04-17 14:00:00.000000Z", name: "some name", password_hash: "some password_hash", reset_password_sent_at: "2010-04-17 14:00:00.000000Z", reset_password_token: "some reset_password_token", sign_in_count: 42, unlock_token: "some unlock_token"}
    @update_attrs %{confirmation_sent_at: "2011-05-18 15:01:01.000000Z", confirmation_token: "some updated confirmation_token", confirmed_at: "2011-05-18 15:01:01.000000Z", current_sign_in_at: "2011-05-18 15:01:01.000000Z", current_sign_in_ip: "some updated current_sign_in_ip", email: "some updated email", failed_attempts: 43, last_sign_in_at: "2011-05-18 15:01:01.000000Z", last_sign_in_ip: "some updated last_sign_in_ip", locked_at: "2011-05-18 15:01:01.000000Z", name: "some updated name", password_hash: "some updated password_hash", reset_password_sent_at: "2011-05-18 15:01:01.000000Z", reset_password_token: "some updated reset_password_token", sign_in_count: 43, unlock_token: "some updated unlock_token"}
    @invalid_attrs %{confirmation_sent_at: nil, confirmation_token: nil, confirmed_at: nil, current_sign_in_at: nil, current_sign_in_ip: nil, email: nil, failed_attempts: nil, last_sign_in_at: nil, last_sign_in_ip: nil, locked_at: nil, name: nil, password_hash: nil, reset_password_sent_at: nil, reset_password_token: nil, sign_in_count: nil, unlock_token: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "paginate_users/1 returns paginated list of users" do
      for _ <- 1..20 do
        user_fixture()
      end

      {:ok, %{users: users} = page} = Account.paginate_users(%{})

      assert length(users) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.confirmation_sent_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert user.confirmation_token == "some confirmation_token"
      assert user.confirmed_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert user.current_sign_in_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert user.current_sign_in_ip == "some current_sign_in_ip"
      assert user.email == "some email"
      assert user.failed_attempts == 42
      assert user.last_sign_in_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert user.last_sign_in_ip == "some last_sign_in_ip"
      assert user.locked_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
      assert user.reset_password_sent_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert user.reset_password_token == "some reset_password_token"
      assert user.sign_in_count == 42
      assert user.unlock_token == "some unlock_token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.confirmation_sent_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert user.confirmation_token == "some updated confirmation_token"
      assert user.confirmed_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert user.current_sign_in_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert user.current_sign_in_ip == "some updated current_sign_in_ip"
      assert user.email == "some updated email"
      assert user.failed_attempts == 43
      assert user.last_sign_in_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert user.last_sign_in_ip == "some updated last_sign_in_ip"
      assert user.locked_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
      assert user.reset_password_sent_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert user.reset_password_token == "some updated reset_password_token"
      assert user.sign_in_count == 43
      assert user.unlock_token == "some updated unlock_token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "user_identities" do
    alias DropAlley.Account.UserIdentity

    @valid_attrs %{provider: "some provider", uid: "some uid", user_id: 42}
    @update_attrs %{provider: "some updated provider", uid: "some updated uid", user_id: 43}
    @invalid_attrs %{provider: nil, uid: nil, user_id: nil}

    def user_identity_fixture(attrs \\ %{}) do
      {:ok, user_identity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user_identity()

      user_identity
    end

    test "paginate_user_identities/1 returns paginated list of user_identities" do
      for _ <- 1..20 do
        user_identity_fixture()
      end

      {:ok, %{user_identities: user_identities} = page} = Account.paginate_user_identities(%{})

      assert length(user_identities) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_user_identities/0 returns all user_identities" do
      user_identity = user_identity_fixture()
      assert Account.list_user_identities() == [user_identity]
    end

    test "get_user_identity!/1 returns the user_identity with given id" do
      user_identity = user_identity_fixture()
      assert Account.get_user_identity!(user_identity.id) == user_identity
    end

    test "create_user_identity/1 with valid data creates a user_identity" do
      assert {:ok, %UserIdentity{} = user_identity} = Account.create_user_identity(@valid_attrs)
      assert user_identity.provider == "some provider"
      assert user_identity.uid == "some uid"
      assert user_identity.user_id == 42
    end

    test "create_user_identity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user_identity(@invalid_attrs)
    end

    test "update_user_identity/2 with valid data updates the user_identity" do
      user_identity = user_identity_fixture()
      assert {:ok, user_identity} = Account.update_user_identity(user_identity, @update_attrs)
      assert %UserIdentity{} = user_identity
      assert user_identity.provider == "some updated provider"
      assert user_identity.uid == "some updated uid"
      assert user_identity.user_id == 43
    end

    test "update_user_identity/2 with invalid data returns error changeset" do
      user_identity = user_identity_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user_identity(user_identity, @invalid_attrs)
      assert user_identity == Account.get_user_identity!(user_identity.id)
    end

    test "delete_user_identity/1 deletes the user_identity" do
      user_identity = user_identity_fixture()
      assert {:ok, %UserIdentity{}} = Account.delete_user_identity(user_identity)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user_identity!(user_identity.id) end
    end

    test "change_user_identity/1 returns a user_identity changeset" do
      user_identity = user_identity_fixture()
      assert %Ecto.Changeset{} = Account.change_user_identity(user_identity)
    end
  end

  describe "invitations" do
    alias DropAlley.Account.Invitation

    @valid_attrs %{email: "some email", name: "some name", token: "some token"}
    @update_attrs %{email: "some updated email", name: "some updated name", token: "some updated token"}
    @invalid_attrs %{email: nil, name: nil, token: nil}

    def invitation_fixture(attrs \\ %{}) do
      {:ok, invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_invitation()

      invitation
    end

    test "paginate_invitations/1 returns paginated list of invitations" do
      for _ <- 1..20 do
        invitation_fixture()
      end

      {:ok, %{invitations: invitations} = page} = Account.paginate_invitations(%{})

      assert length(invitations) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_invitations/0 returns all invitations" do
      invitation = invitation_fixture()
      assert Account.list_invitations() == [invitation]
    end

    test "get_invitation!/1 returns the invitation with given id" do
      invitation = invitation_fixture()
      assert Account.get_invitation!(invitation.id) == invitation
    end

    test "create_invitation/1 with valid data creates a invitation" do
      assert {:ok, %Invitation{} = invitation} = Account.create_invitation(@valid_attrs)
      assert invitation.email == "some email"
      assert invitation.name == "some name"
      assert invitation.token == "some token"
    end

    test "create_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_invitation(@invalid_attrs)
    end

    test "update_invitation/2 with valid data updates the invitation" do
      invitation = invitation_fixture()
      assert {:ok, invitation} = Account.update_invitation(invitation, @update_attrs)
      assert %Invitation{} = invitation
      assert invitation.email == "some updated email"
      assert invitation.name == "some updated name"
      assert invitation.token == "some updated token"
    end

    test "update_invitation/2 with invalid data returns error changeset" do
      invitation = invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_invitation(invitation, @invalid_attrs)
      assert invitation == Account.get_invitation!(invitation.id)
    end

    test "delete_invitation/1 deletes the invitation" do
      invitation = invitation_fixture()
      assert {:ok, %Invitation{}} = Account.delete_invitation(invitation)
      assert_raise Ecto.NoResultsError, fn -> Account.get_invitation!(invitation.id) end
    end

    test "change_invitation/1 returns a invitation changeset" do
      invitation = invitation_fixture()
      assert %Ecto.Changeset{} = Account.change_invitation(invitation)
    end
  end
end
