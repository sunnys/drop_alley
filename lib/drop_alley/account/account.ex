defmodule DropAlley.Account do
  @moduledoc """
  The Account context.
  """
  
  import Ecto.Query, warn: false
  alias DropAlley.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config
  
  alias DropAlley.Coherence.User
  alias DropAlley.Account.UserIdentity
  alias DropAlley.Account.Invitation
  
  @pagination [page_size: 15]
  @pagination_distance 5
@doc """
Paginate the list of users using filtrex
filters.

## Examples

    iex> list_users(%{})
    %{users: [%User{}], ...}
"""
@spec paginate_users(map) :: {:ok, map} | {:error, any}
def paginate_users(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:users), params["user"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_users(filter, params) do
    {:ok,
      %{
        users: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_users(filter, params) do
  User
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of users.

## Examples

    iex> list_users()
    [%User{}, ...]

"""
def list_users do
  Repo.all(User)
end

@doc """
Gets a single user.

Raises `Ecto.NoResultsError` if the User does not exist.

## Examples

    iex> get_user!(123)
    %User{}

    iex> get_user!(456)
    ** (Ecto.NoResultsError)

"""
def get_user!(id), do: Repo.get!(User, id)

@doc """
Creates a user.

## Examples

    iex> create_user(%{field: value})
    {:ok, %User{}}

    iex> create_user(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_user(attrs \\ %{}) do
  %User{}
  |> User.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a user.

## Examples

    iex> update_user(user, %{field: new_value})
    {:ok, %User{}}

    iex> update_user(user, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_user(%User{} = user, attrs) do
  user
  |> User.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a User.

## Examples

    iex> delete_user(user)
    {:ok, %User{}}

    iex> delete_user(user)
    {:error, %Ecto.Changeset{}}

"""
def delete_user(%User{} = user) do
  Repo.delete(user)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking user changes.

## Examples

    iex> change_user(user)
    %Ecto.Changeset{source: %User{}}

"""
def change_user(%User{} = user) do
  User.changeset(user, %{})
end

defp filter_config(:users) do
  defconfig do
    text :name
    text :email
  end
end

@doc """
Paginate the list of user_identities using filtrex
filters.

## Examples

    iex> list_user_identities(%{})
    %{user_identities: [%UserIdentity{}], ...}
"""
@spec paginate_user_identities(map) :: {:ok, map} | {:error, any}
def paginate_user_identities(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config_user_identity(:user_identities), params["user_identity"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_user_identities(filter, params) do
    {:ok,
      %{
        user_identities: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_user_identities(filter, params) do
  UserIdentity
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of user_identities.

## Examples

    iex> list_user_identities()
    [%UserIdentity{}, ...]

"""
def list_user_identities do
  Repo.all(UserIdentity)
end

@doc """
Gets a single user_identity.

Raises `Ecto.NoResultsError` if the User identity does not exist.

## Examples

    iex> get_user_identity!(123)
    %UserIdentity{}

    iex> get_user_identity!(456)
    ** (Ecto.NoResultsError)

"""
def get_user_identity!(id), do: Repo.get!(UserIdentity, id)

@doc """
Creates a user_identity.

## Examples

    iex> create_user_identity(%{field: value})
    {:ok, %UserIdentity{}}

    iex> create_user_identity(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_user_identity(attrs \\ %{}) do
  %UserIdentity{}
  |> UserIdentity.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a user_identity.

## Examples

    iex> update_user_identity(user_identity, %{field: new_value})
    {:ok, %UserIdentity{}}

    iex> update_user_identity(user_identity, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_user_identity(%UserIdentity{} = user_identity, attrs) do
  user_identity
  |> UserIdentity.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a UserIdentity.

## Examples

    iex> delete_user_identity(user_identity)
    {:ok, %UserIdentity{}}

    iex> delete_user_identity(user_identity)
    {:error, %Ecto.Changeset{}}

"""
def delete_user_identity(%UserIdentity{} = user_identity) do
  Repo.delete(user_identity)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking user_identity changes.

## Examples

    iex> change_user_identity(user_identity)
    %Ecto.Changeset{source: %UserIdentity{}}

"""
def change_user_identity(%UserIdentity{} = user_identity) do
  UserIdentity.changeset(user_identity, %{})
end

defp filter_config_user_identity(:user_identities) do
  defconfig do
    number :user_id
      text :provider
      text :uid
      
  end
end

@doc """
Paginate the list of invitations using filtrex
filters.

## Examples

    iex> list_invitations(%{})
    %{invitations: [%Invitation{}], ...}
"""
@spec paginate_invitations(map) :: {:ok, map} | {:error, any}
def paginate_invitations(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config_invitation(:invitations), params["invitation"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_invitations(filter, params) do
    {:ok,
      %{
        invitations: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_invitations(filter, params) do
  Invitation
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of invitations.

## Examples

    iex> list_invitations()
    [%Invitation{}, ...]

"""
def list_invitations do
  Repo.all(Invitation)
end

@doc """
Gets a single invitation.

Raises `Ecto.NoResultsError` if the Invitation does not exist.

## Examples

    iex> get_invitation!(123)
    %Invitation{}

    iex> get_invitation!(456)
    ** (Ecto.NoResultsError)

"""
def get_invitation!(id), do: Repo.get!(Invitation, id)

@doc """
Creates a invitation.

## Examples

    iex> create_invitation(%{field: value})
    {:ok, %Invitation{}}

    iex> create_invitation(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_invitation(attrs \\ %{}) do
  %Invitation{}
  |> Invitation.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a invitation.

## Examples

    iex> update_invitation(invitation, %{field: new_value})
    {:ok, %Invitation{}}

    iex> update_invitation(invitation, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_invitation(%Invitation{} = invitation, attrs) do
  invitation
  |> Invitation.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Invitation.

## Examples

    iex> delete_invitation(invitation)
    {:ok, %Invitation{}}

    iex> delete_invitation(invitation)
    {:error, %Ecto.Changeset{}}

"""
def delete_invitation(%Invitation{} = invitation) do
  Repo.delete(invitation)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking invitation changes.

## Examples

    iex> change_invitation(invitation)
    %Ecto.Changeset{source: %Invitation{}}

"""
def change_invitation(%Invitation{} = invitation) do
  Invitation.changeset(invitation, %{})
end

defp filter_config_invitation(:invitations) do
  defconfig do
    text :name
      text :email
      text :token
      
  end
end
end
