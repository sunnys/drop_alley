defmodule DropAlley.StoreTest do
  use DropAlley.DataCase

  alias DropAlley.Store

  describe "products" do
    alias DropAlley.Store.Product

    @valid_attrs %{description: "some description", inspection_process: %{}, name: "some name", prprice: 120.5, state: "some state"}
    @update_attrs %{description: "some updated description", inspection_process: %{}, name: "some updated name", prprice: 456.7, state: "some updated state"}
    @invalid_attrs %{description: nil, inspection_process: nil, name: nil, prprice: nil, state: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_product()

      product
    end

    test "paginate_products/1 returns paginated list of products" do
      for _ <- 1..20 do
        product_fixture()
      end

      {:ok, %{products: products} = page} = Store.paginate_products(%{})

      assert length(products) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Store.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Store.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Store.create_product(@valid_attrs)
      assert product.description == "some description"
      assert product.inspection_process == %{}
      assert product.name == "some name"
      assert product.prprice == 120.5
      assert product.state == "some state"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Store.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.description == "some updated description"
      assert product.inspection_process == %{}
      assert product.name == "some updated name"
      assert product.prprice == 456.7
      assert product.state == "some updated state"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product(product, @invalid_attrs)
      assert product == Store.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Store.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Store.change_product(product)
    end
  end

  describe "buyers" do
    alias DropAlley.Store.Buyer

    @valid_attrs %{active: true}
    @update_attrs %{active: false}
    @invalid_attrs %{active: nil}

    def buyer_fixture(attrs \\ %{}) do
      {:ok, buyer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_buyer()

      buyer
    end

    test "paginate_buyers/1 returns paginated list of buyers" do
      for _ <- 1..20 do
        buyer_fixture()
      end

      {:ok, %{buyers: buyers} = page} = Store.paginate_buyers(%{})

      assert length(buyers) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_buyers/0 returns all buyers" do
      buyer = buyer_fixture()
      assert Store.list_buyers() == [buyer]
    end

    test "get_buyer!/1 returns the buyer with given id" do
      buyer = buyer_fixture()
      assert Store.get_buyer!(buyer.id) == buyer
    end

    test "create_buyer/1 with valid data creates a buyer" do
      assert {:ok, %Buyer{} = buyer} = Store.create_buyer(@valid_attrs)
      assert buyer.active == true
    end

    test "create_buyer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_buyer(@invalid_attrs)
    end

    test "update_buyer/2 with valid data updates the buyer" do
      buyer = buyer_fixture()
      assert {:ok, buyer} = Store.update_buyer(buyer, @update_attrs)
      assert %Buyer{} = buyer
      assert buyer.active == false
    end

    test "update_buyer/2 with invalid data returns error changeset" do
      buyer = buyer_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_buyer(buyer, @invalid_attrs)
      assert buyer == Store.get_buyer!(buyer.id)
    end

    test "delete_buyer/1 deletes the buyer" do
      buyer = buyer_fixture()
      assert {:ok, %Buyer{}} = Store.delete_buyer(buyer)
      assert_raise Ecto.NoResultsError, fn -> Store.get_buyer!(buyer.id) end
    end

    test "change_buyer/1 returns a buyer changeset" do
      buyer = buyer_fixture()
      assert %Ecto.Changeset{} = Store.change_buyer(buyer)
    end
  end

  describe "return_consumers" do
    alias DropAlley.Store.ReturnConsumer

    @valid_attrs %{active: true}
    @update_attrs %{active: false}
    @invalid_attrs %{active: nil}

    def return_consumer_fixture(attrs \\ %{}) do
      {:ok, return_consumer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_return_consumer()

      return_consumer
    end

    test "paginate_return_consumers/1 returns paginated list of return_consumers" do
      for _ <- 1..20 do
        return_consumer_fixture()
      end

      {:ok, %{return_consumers: return_consumers} = page} = Store.paginate_return_consumers(%{})

      assert length(return_consumers) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_return_consumers/0 returns all return_consumers" do
      return_consumer = return_consumer_fixture()
      assert Store.list_return_consumers() == [return_consumer]
    end

    test "get_return_consumer!/1 returns the return_consumer with given id" do
      return_consumer = return_consumer_fixture()
      assert Store.get_return_consumer!(return_consumer.id) == return_consumer
    end

    test "create_return_consumer/1 with valid data creates a return_consumer" do
      assert {:ok, %ReturnConsumer{} = return_consumer} = Store.create_return_consumer(@valid_attrs)
      assert return_consumer.active == true
    end

    test "create_return_consumer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_return_consumer(@invalid_attrs)
    end

    test "update_return_consumer/2 with valid data updates the return_consumer" do
      return_consumer = return_consumer_fixture()
      assert {:ok, return_consumer} = Store.update_return_consumer(return_consumer, @update_attrs)
      assert %ReturnConsumer{} = return_consumer
      assert return_consumer.active == false
    end

    test "update_return_consumer/2 with invalid data returns error changeset" do
      return_consumer = return_consumer_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_return_consumer(return_consumer, @invalid_attrs)
      assert return_consumer == Store.get_return_consumer!(return_consumer.id)
    end

    test "delete_return_consumer/1 deletes the return_consumer" do
      return_consumer = return_consumer_fixture()
      assert {:ok, %ReturnConsumer{}} = Store.delete_return_consumer(return_consumer)
      assert_raise Ecto.NoResultsError, fn -> Store.get_return_consumer!(return_consumer.id) end
    end

    test "change_return_consumer/1 returns a return_consumer changeset" do
      return_consumer = return_consumer_fixture()
      assert %Ecto.Changeset{} = Store.change_return_consumer(return_consumer)
    end
  end

  describe "retailers" do
    alias DropAlley.Store.Retailer

    @valid_attrs %{active: true, api_key: "some api_key", details: %{}, name: "some name"}
    @update_attrs %{active: false, api_key: "some updated api_key", details: %{}, name: "some updated name"}
    @invalid_attrs %{active: nil, api_key: nil, details: nil, name: nil}

    def retailer_fixture(attrs \\ %{}) do
      {:ok, retailer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_retailer()

      retailer
    end

    test "paginate_retailers/1 returns paginated list of retailers" do
      for _ <- 1..20 do
        retailer_fixture()
      end

      {:ok, %{retailers: retailers} = page} = Store.paginate_retailers(%{})

      assert length(retailers) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_retailers/0 returns all retailers" do
      retailer = retailer_fixture()
      assert Store.list_retailers() == [retailer]
    end

    test "get_retailer!/1 returns the retailer with given id" do
      retailer = retailer_fixture()
      assert Store.get_retailer!(retailer.id) == retailer
    end

    test "create_retailer/1 with valid data creates a retailer" do
      assert {:ok, %Retailer{} = retailer} = Store.create_retailer(@valid_attrs)
      assert retailer.active == true
      assert retailer.api_key == "some api_key"
      assert retailer.details == %{}
      assert retailer.name == "some name"
    end

    test "create_retailer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_retailer(@invalid_attrs)
    end

    test "update_retailer/2 with valid data updates the retailer" do
      retailer = retailer_fixture()
      assert {:ok, retailer} = Store.update_retailer(retailer, @update_attrs)
      assert %Retailer{} = retailer
      assert retailer.active == false
      assert retailer.api_key == "some updated api_key"
      assert retailer.details == %{}
      assert retailer.name == "some updated name"
    end

    test "update_retailer/2 with invalid data returns error changeset" do
      retailer = retailer_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_retailer(retailer, @invalid_attrs)
      assert retailer == Store.get_retailer!(retailer.id)
    end

    test "delete_retailer/1 deletes the retailer" do
      retailer = retailer_fixture()
      assert {:ok, %Retailer{}} = Store.delete_retailer(retailer)
      assert_raise Ecto.NoResultsError, fn -> Store.get_retailer!(retailer.id) end
    end

    test "change_retailer/1 returns a retailer changeset" do
      retailer = retailer_fixture()
      assert %Ecto.Changeset{} = Store.change_retailer(retailer)
    end
  end

  describe "product_images" do
    alias DropAlley.Store.ProductImage

    @valid_attrs %{image: "some image"}
    @update_attrs %{image: "some updated image"}
    @invalid_attrs %{image: nil}

    def product_image_fixture(attrs \\ %{}) do
      {:ok, product_image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_product_image()

      product_image
    end

    test "paginate_product_images/1 returns paginated list of product_images" do
      for _ <- 1..20 do
        product_image_fixture()
      end

      {:ok, %{product_images: product_images} = page} = Store.paginate_product_images(%{})

      assert length(product_images) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_product_images/0 returns all product_images" do
      product_image = product_image_fixture()
      assert Store.list_product_images() == [product_image]
    end

    test "get_product_image!/1 returns the product_image with given id" do
      product_image = product_image_fixture()
      assert Store.get_product_image!(product_image.id) == product_image
    end

    test "create_product_image/1 with valid data creates a product_image" do
      assert {:ok, %ProductImage{} = product_image} = Store.create_product_image(@valid_attrs)
      assert product_image.image == "some image"
    end

    test "create_product_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product_image(@invalid_attrs)
    end

    test "update_product_image/2 with valid data updates the product_image" do
      product_image = product_image_fixture()
      assert {:ok, product_image} = Store.update_product_image(product_image, @update_attrs)
      assert %ProductImage{} = product_image
      assert product_image.image == "some updated image"
    end

    test "update_product_image/2 with invalid data returns error changeset" do
      product_image = product_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product_image(product_image, @invalid_attrs)
      assert product_image == Store.get_product_image!(product_image.id)
    end

    test "delete_product_image/1 deletes the product_image" do
      product_image = product_image_fixture()
      assert {:ok, %ProductImage{}} = Store.delete_product_image(product_image)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product_image!(product_image.id) end
    end

    test "change_product_image/1 returns a product_image changeset" do
      product_image = product_image_fixture()
      assert %Ecto.Changeset{} = Store.change_product_image(product_image)
    end
  end

  describe "product_reviews" do
    alias DropAlley.Store.ProductReview

    @valid_attrs %{image: "some image", name: "some name", rating: 42}
    @update_attrs %{image: "some updated image", name: "some updated name", rating: 43}
    @invalid_attrs %{image: nil, name: nil, rating: nil}

    def product_review_fixture(attrs \\ %{}) do
      {:ok, product_review} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Store.create_product_review()

      product_review
    end

    test "paginate_product_reviews/1 returns paginated list of product_reviews" do
      for _ <- 1..20 do
        product_review_fixture()
      end

      {:ok, %{product_reviews: product_reviews} = page} = Store.paginate_product_reviews(%{})

      assert length(product_reviews) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_product_reviews/0 returns all product_reviews" do
      product_review = product_review_fixture()
      assert Store.list_product_reviews() == [product_review]
    end

    test "get_product_review!/1 returns the product_review with given id" do
      product_review = product_review_fixture()
      assert Store.get_product_review!(product_review.id) == product_review
    end

    test "create_product_review/1 with valid data creates a product_review" do
      assert {:ok, %ProductReview{} = product_review} = Store.create_product_review(@valid_attrs)
      assert product_review.image == "some image"
      assert product_review.name == "some name"
      assert product_review.rating == 42
    end

    test "create_product_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product_review(@invalid_attrs)
    end

    test "update_product_review/2 with valid data updates the product_review" do
      product_review = product_review_fixture()
      assert {:ok, product_review} = Store.update_product_review(product_review, @update_attrs)
      assert %ProductReview{} = product_review
      assert product_review.image == "some updated image"
      assert product_review.name == "some updated name"
      assert product_review.rating == 43
    end

    test "update_product_review/2 with invalid data returns error changeset" do
      product_review = product_review_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product_review(product_review, @invalid_attrs)
      assert product_review == Store.get_product_review!(product_review.id)
    end

    test "delete_product_review/1 deletes the product_review" do
      product_review = product_review_fixture()
      assert {:ok, %ProductReview{}} = Store.delete_product_review(product_review)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product_review!(product_review.id) end
    end

    test "change_product_review/1 returns a product_review changeset" do
      product_review = product_review_fixture()
      assert %Ecto.Changeset{} = Store.change_product_review(product_review)
    end
  end
end
