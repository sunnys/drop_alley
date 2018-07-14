defmodule DropAlley.Store do
  @moduledoc """
  The Store context.
  """
  
  import Ecto.Query, warn: false
  alias DropAlley.Repo
  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config
  
  alias DropAlley.Store.Product
  alias DropAlley.Store.ProductImage
  alias DropAlley.Store.Retailer
  alias DropAlley.Store.Buyer
  alias DropAlley.Store.ReturnConsumer

  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

  @pagination [page_size: 15]
  @pagination_distance 5

@doc """
Paginate the list of products using filtrex
filters.

## Examples

    iex> list_products(%{})
    %{products: [%Product{}], ...}
"""
@spec paginate_products(map) :: {:ok, map} | {:error, any}
def paginate_products(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_product_config(:products), params["product"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_products(filter, params) do
    {:ok,
      %{
        products: page.entries,
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

defp do_paginate_products(filter, params) do
  Product
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of products.

## Examples

    iex> list_products()
    [%Product{}, ...]

"""
def list_products do
  Repo.all(Product)
end

@doc """
Gets a single product.

Raises `Ecto.NoResultsError` if the Product does not exist.

## Examples

    iex> get_product!(123)
    %Product{}

    iex> get_product!(456)
    ** (Ecto.NoResultsError)

"""
def get_product!(id), do: Repo.get!(Product, id)

def get_product_with_detail!(id), do: Repo.get!(Product, id) |> Repo.preload([:product_images, :product_reviews])

@doc """
Gets a single product by return code.

Raises `Ecto.NoResultsError` if the Product does not exist.

## Examples

    iex> get_product_by_return_code!("asasas-asasa-asasasa")
    %Product{}

    iex> get_product_by_return_code!("asasas-asasa-asasasa")
    ** (Ecto.NoResultsError)

"""
def get_product_by_return_code!(code), do: Repo.get_by!(Product, %{return_code: code})

def set_return_consumer(code, return_consumer_id) do
  product = get_product_by_return_code!(code)
  product
  |> Product.changeset(%{return_consumer_id: return_consumer_id})
  |> Repo.update
end

@doc """
Creates a product.

## Examples

    iex> create_product(%{field: value})
    {:ok, %Product{}}

    iex> create_product(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_product(attrs \\ %{}) do
  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a product.

## Examples

    iex> update_product(product, %{field: new_value})
    {:ok, %Product{}}

    iex> update_product(product, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_product(%Product{} = product, attrs) do
  product
  |> Product.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Product.

## Examples

    iex> delete_product(product)
    {:ok, %Product{}}

    iex> delete_product(product)
    {:error, %Ecto.Changeset{}}

"""
def delete_product(%Product{} = product) do
  Repo.delete(product)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking product changes.

## Examples

    iex> change_product(product)
    %Ecto.Changeset{source: %Product{}}

"""
def change_product(%Product{} = product) do
  Product.changeset(product, %{})
end

defp filter_product_config(:products) do
  defconfig do
    text :name
      text :description
       #TODO add config for prprice of type float
    text :state
       #TODO add config for inspection_process of type map
    
  end
end

@doc """
Create multipple product with csv upload
"""
def create_bulk_product(file_name) do
  file_name 
  |> 
  File.stream! 
  |> MyParser.parse_stream 
  |> Stream.map(fn[name, image, description, prprice,  price, state, retailer_id, product_image1, product_image2, product_image3, product_image4] -> 
    Product.changeset(%Product{}, %{
      name: name, 
      image: image, 
      description: description, 
      prprice: prprice, 
      price: price, 
      state: state, 
      retailer_id: retailer_id, 
      product_images: [
        %{image: product_image1}, 
        %{image: product_image2}, 
        %{image: product_image3}, 
        %{image: product_image4}
      ]
    }) 
    |> 
    Repo.insert! 
  end) 
  |> Enum.to_list

end

@doc """
Paginate the list of buyers using filtrex
filters.

## Examples

    iex> list_buyers(%{})
    %{buyers: [%Buyer{}], ...}
"""
@spec paginate_buyers(map) :: {:ok, map} | {:error, any}
def paginate_buyers(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_buyer_config(:buyers), params["buyer"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_buyers(filter, params) do
    {:ok,
      %{
        buyers: page.entries,
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

defp do_paginate_buyers(filter, params) do
  Buyer
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of buyers.

## Examples

    iex> list_buyers()
    [%Buyer{}, ...]

"""
def list_buyers do
  Repo.all(Buyer)
end

@doc """
Gets a single buyer.

Raises `Ecto.NoResultsError` if the Buyer does not exist.

## Examples

    iex> get_buyer!(123)
    %Buyer{}

    iex> get_buyer!(456)
    ** (Ecto.NoResultsError)

"""
def get_buyer!(id), do: Repo.get!(Buyer, id)

@doc """
Creates a buyer.

## Examples

    iex> create_buyer(%{field: value})
    {:ok, %Buyer{}}

    iex> create_buyer(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_buyer(attrs \\ %{}) do
  %Buyer{}
  |> Buyer.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a buyer.

## Examples

    iex> update_buyer(buyer, %{field: new_value})
    {:ok, %Buyer{}}

    iex> update_buyer(buyer, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_buyer(%Buyer{} = buyer, attrs) do
  buyer
  |> Buyer.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Buyer.

## Examples

    iex> delete_buyer(buyer)
    {:ok, %Buyer{}}

    iex> delete_buyer(buyer)
    {:error, %Ecto.Changeset{}}

"""
def delete_buyer(%Buyer{} = buyer) do
  Repo.delete(buyer)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking buyer changes.

## Examples

    iex> change_buyer(buyer)
    %Ecto.Changeset{source: %Buyer{}}

"""
def change_buyer(%Buyer{} = buyer) do
  Buyer.changeset(buyer, %{})
end

defp filter_buyer_config(:buyers) do
  defconfig do
    boolean :active
      
  end
end

@doc """
Paginate the list of return_consumers using filtrex
filters.

## Examples

    iex> list_return_consumers(%{})
    %{return_consumers: [%ReturnConsumer{}], ...}
"""
@spec paginate_return_consumers(map) :: {:ok, map} | {:error, any}
def paginate_return_consumers(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_return_config(:return_consumers), params["return_consumer"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_return_consumers(filter, params) do
    {:ok,
      %{
        return_consumers: page.entries,
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

defp do_paginate_return_consumers(filter, params) do
  ReturnConsumer
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of return_consumers.

## Examples

    iex> list_return_consumers()
    [%ReturnConsumer{}, ...]

"""
def list_return_consumers do
  Repo.all(ReturnConsumer)
end

@doc """
Gets a single return_consumer.

Raises `Ecto.NoResultsError` if the Return consumer does not exist.

## Examples

    iex> get_return_consumer!(123)
    %ReturnConsumer{}

    iex> get_return_consumer!(456)
    ** (Ecto.NoResultsError)

"""
def get_return_consumer!(id), do: Repo.get!(ReturnConsumer, id)

@doc """
Creates a return_consumer.

## Examples

    iex> create_return_consumer(%{field: value})
    {:ok, %ReturnConsumer{}}

    iex> create_return_consumer(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_return_consumer(attrs \\ %{}) do
  %ReturnConsumer{}
  |> ReturnConsumer.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a return_consumer.

## Examples

    iex> update_return_consumer(return_consumer, %{field: new_value})
    {:ok, %ReturnConsumer{}}

    iex> update_return_consumer(return_consumer, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_return_consumer(%ReturnConsumer{} = return_consumer, attrs) do
  return_consumer
  |> ReturnConsumer.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a ReturnConsumer.

## Examples

    iex> delete_return_consumer(return_consumer)
    {:ok, %ReturnConsumer{}}

    iex> delete_return_consumer(return_consumer)
    {:error, %Ecto.Changeset{}}

"""
def delete_return_consumer(%ReturnConsumer{} = return_consumer) do
  Repo.delete(return_consumer)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking return_consumer changes.

## Examples

    iex> change_return_consumer(return_consumer)
    %Ecto.Changeset{source: %ReturnConsumer{}}

"""
def change_return_consumer(%ReturnConsumer{} = return_consumer) do
  ReturnConsumer.changeset(return_consumer, %{})
end

defp filter_return_config(:return_consumers) do
  defconfig do
    boolean :active
      
  end
end

@doc """
Paginate the list of retailers using filtrex
filters.

## Examples

    iex> list_retailers(%{})
    %{retailers: [%Retailer{}], ...}
"""
@spec paginate_retailers(map) :: {:ok, map} | {:error, any}
def paginate_retailers(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_retailer_config(:retailers), params["retailer"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_retailers(filter, params) do
    {:ok,
      %{
        retailers: page.entries,
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

defp do_paginate_retailers(filter, params) do
  Retailer
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of retailers.

## Examples

    iex> list_retailers()
    [%Retailer{}, ...]

"""
def list_retailers do
  Repo.all(Retailer)
end

@doc """
Gets a single retailer.

Raises `Ecto.NoResultsError` if the Retailer does not exist.

## Examples

    iex> get_retailer!(123)
    %Retailer{}

    iex> get_retailer!(456)
    ** (Ecto.NoResultsError)

"""
def get_retailer!(id), do: Repo.get!(Retailer, id)

@doc """
Creates a retailer.

## Examples

    iex> create_retailer(%{field: value})
    {:ok, %Retailer{}}

    iex> create_retailer(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_retailer(attrs \\ %{}) do
  %Retailer{}
  |> Retailer.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a retailer.

## Examples

    iex> update_retailer(retailer, %{field: new_value})
    {:ok, %Retailer{}}

    iex> update_retailer(retailer, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_retailer(%Retailer{} = retailer, attrs) do
  retailer
  |> Retailer.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Retailer.

## Examples

    iex> delete_retailer(retailer)
    {:ok, %Retailer{}}

    iex> delete_retailer(retailer)
    {:error, %Ecto.Changeset{}}

"""
def delete_retailer(%Retailer{} = retailer) do
  Repo.delete(retailer)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking retailer changes.

## Examples

    iex> change_retailer(retailer)
    %Ecto.Changeset{source: %Retailer{}}

"""
def change_retailer(%Retailer{} = retailer) do
  Retailer.changeset(retailer, %{})
end

defp filter_retailer_config(:retailers) do
  defconfig do
    text :name
      text :api_key
       #TODO add config for details of type map
    boolean :active
      
  end
end
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias DropAlley.Store.ProductImage

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of product_images using filtrex
filters.

## Examples

    iex> list_product_images(%{})
    %{product_images: [%ProductImage{}], ...}
"""
@spec paginate_product_images(map) :: {:ok, map} | {:error, any}
def paginate_product_images(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:product_images), params["product_image"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_product_images(filter, params) do
    {:ok,
      %{
        product_images: page.entries,
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

defp do_paginate_product_images(filter, params) do
  ProductImage
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of product_images.

## Examples

    iex> list_product_images()
    [%ProductImage{}, ...]

"""
def list_product_images do
  Repo.all(ProductImage)
end

@doc """
Gets a single product_image.

Raises `Ecto.NoResultsError` if the Product image does not exist.

## Examples

    iex> get_product_image!(123)
    %ProductImage{}

    iex> get_product_image!(456)
    ** (Ecto.NoResultsError)

"""
def get_product_image!(id), do: Repo.get!(ProductImage, id)

@doc """
Creates a product_image.

## Examples

    iex> create_product_image(%{field: value})
    {:ok, %ProductImage{}}

    iex> create_product_image(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_product_image(attrs \\ %{}) do
  %ProductImage{}
  |> ProductImage.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a product_image.

## Examples

    iex> update_product_image(product_image, %{field: new_value})
    {:ok, %ProductImage{}}

    iex> update_product_image(product_image, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_product_image(%ProductImage{} = product_image, attrs) do
  product_image
  |> ProductImage.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a ProductImage.

## Examples

    iex> delete_product_image(product_image)
    {:ok, %ProductImage{}}

    iex> delete_product_image(product_image)
    {:error, %Ecto.Changeset{}}

"""
def delete_product_image(%ProductImage{} = product_image) do
  Repo.delete(product_image)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking product_image changes.

## Examples

    iex> change_product_image(product_image)
    %Ecto.Changeset{source: %ProductImage{}}

"""
def change_product_image(%ProductImage{} = product_image) do
  ProductImage.changeset(product_image, %{})
end

defp filter_config(:product_images) do
  defconfig do
    text :image
      
  end
end
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias DropAlley.Store.ProductReview

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of product_reviews using filtrex
filters.

## Examples

    iex> list_product_reviews(%{})
    %{product_reviews: [%ProductReview{}], ...}
"""
@spec paginate_product_reviews(map) :: {:ok, map} | {:error, any}
def paginate_product_reviews(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:product_reviews), params["product_review"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_product_reviews(filter, params) do
    {:ok,
      %{
        product_reviews: page.entries,
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

defp do_paginate_product_reviews(filter, params) do
  ProductReview
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of product_reviews.

## Examples

    iex> list_product_reviews()
    [%ProductReview{}, ...]

"""
def list_product_reviews do
  Repo.all(ProductReview)
end

@doc """
Gets a single product_review.

Raises `Ecto.NoResultsError` if the Product review does not exist.

## Examples

    iex> get_product_review!(123)
    %ProductReview{}

    iex> get_product_review!(456)
    ** (Ecto.NoResultsError)

"""
def get_product_review!(id), do: Repo.get!(ProductReview, id)

@doc """
Creates a product_review.

## Examples

    iex> create_product_review(%{field: value})
    {:ok, %ProductReview{}}

    iex> create_product_review(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_product_review(attrs \\ %{}) do
  %ProductReview{}
  |> ProductReview.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a product_review.

## Examples

    iex> update_product_review(product_review, %{field: new_value})
    {:ok, %ProductReview{}}

    iex> update_product_review(product_review, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_product_review(%ProductReview{} = product_review, attrs) do
  product_review
  |> ProductReview.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a ProductReview.

## Examples

    iex> delete_product_review(product_review)
    {:ok, %ProductReview{}}

    iex> delete_product_review(product_review)
    {:error, %Ecto.Changeset{}}

"""
def delete_product_review(%ProductReview{} = product_review) do
  Repo.delete(product_review)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking product_review changes.

## Examples

    iex> change_product_review(product_review)
    %Ecto.Changeset{source: %ProductReview{}}

"""
def change_product_review(%ProductReview{} = product_review) do
  ProductReview.changeset(product_review, %{})
end

defp filter_config(:product_reviews) do
  defconfig do
    text :name
      number :rating
      text :image
      
  end
end
end
