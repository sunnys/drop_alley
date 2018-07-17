# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DropAlley.Repo.insert!(%DropAlley.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias FakerElixir, as: Faker
alias DropAlley.Repo
alias DropAlley.Store
alias DropAlley.Store.Product
alias DropAlley.Store.ProductImage
alias DropAlley.Store.ProductReview
alias DropAlley.Store.Retailer

# DropAlley.Repo.delete_all DropAlley.Coherence.User

DropAlley.Coherence.User.changeset(%DropAlley.Coherence.User{}, %{name: "Test User", email: "testuser36@example.com", password: "secret", password_confirmation: "secret"})
|> DropAlley.Repo.insert!
|> Coherence.ControllerHelpers.confirm!

###################### Bearer Token ###################
# bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJkcm9wX2FsbGV5IiwiZXhwIjoxNTMxNzI3MDQ1LCJpYXQiOjE1MjkxMzUwNDUsImlzcyI6ImRyb3BfYWxsZXkiLCJqdGkiOiJlNzhiODUwMy05MjY4LTQ2ZjctYWI1Yi0zMjg4YTE3NjA4YjAiLCJuYmYiOjE1MjkxMzUwNDQsInN1YiI6IjQiLCJ0eXAiOiJhY2Nlc3MifQ.C8rZTu9UeIuVGXbq9SC-ENGg8dvUmv1kZpioilpdudm8XXPhxkeJe2OfD30zDp8ja7pnr3Acx4AWOoG2UFy9Xw

defmodule RetailerSeed do
    def delete_retailers do
        Repo.delete_all(ProductReview)
        Repo.delete_all(ProductImage)
        Repo.delete_all(Product)
        Repo.delete_all(Retailer)
    end

    def seed do
        user = create_user
        r = create_retailer(user)
        for i <- 1..30 do
            p = create_product(r)
            for j <- 1..5 do
                create_product_images(p)
                create_product_reviews(p)
            end
        end
    end

    def create_user do
        DropAlley.Coherence.User.changeset(%DropAlley.Coherence.User{}, %{name: "Test User", email: Faker.Internet.email, password: "secret", password_confirmation: "secret"}) |> Repo.insert!
    end

    def create_retailer(u) do
        Retailer.changeset(%Retailer{}, %{ active: Enum.random([true, false]), name: Faker.Name.first_name(), api_key: UUID.uuid1(), user_id: u.id, detail: %{info: "Asalksjkdjfkd"}}) |> Repo.insert!
    end

    def create_product(r) do
        size = Enum.random(6..15)
        brand = Enum.random(['Reebok', 'Nike', 'Bata', 'Adidas', 'Puma'])
        color = Enum.random(['Black', 'Red', 'Gray', 'Green'])
        material = Enum.random(['Leather', 'Rubber'])
        category = Enum.random(['Shoes', 'Snikers'])
        subcategory = Enum.random(['Canvas', 'Sport', 'Slippers'])
        Product.changeset(%Product{}, %{
            image: FakerElixir.Avatar.robohash, 
            name: Faker.Commerce.product, 
            description: Faker.Lorem.sentence, 
            prprice: Enum.random(1..100), 
            price: Enum.random(1..100), 
            state: Faker.Address.street_address, 
            retailer_id: r.id, 
            discount: Enum.random(20..30), 
            size: Enum.random(6..15) |> Integer.to_string, 
            brand: brand,
            color: color,
            material: material,
            category: category,
            subcategory: subcategory, 
            detail: %{
                size: size,
                brand: brand,
                color: color,
                material: material,
                category: category,
                subcategory: subcategory
            },
            stocks: Enum.map((1..4), fn(i) -> %{address: Faker.Address.street_address, stock: Enum.random(0..50)} end)
        }) |> Repo.insert!
    end

    def create_product_images(p) do
        ProductImage.changeset(%ProductImage{}, %{image: FakerElixir.Avatar.robohash, product_id: p.id}) |> Repo.insert!
    end

    def create_product_reviews(p) do
        ProductReview.changeset(%ProductReview{}, %{image: FakerElixir.Avatar.robohash, product_id: p.id, name: Faker.Name.name, comment: Faker.Lorem.sentence, rating: Enum.random(1..5)}) |> Repo.insert!
    end
end

RetailerSeed.delete_retailers
RetailerSeed.seed       

# "/home/sunny/Desktop/drop_alley_random.csv" |> File.stream! |> MyParser.parse_stream |> Stream.map(fn[name, image, description, prprice,  price, state, retailer_id, product_image1, product_image2, product_image3, product_image4] -> Product.changeset(%Product{}, %{name: name, image: image, description: description, prprice: prprice, price: price, state: state, retailer_id: retailer_id, product_images: [%{image: product_image1}, %{image: product_image2}, %{image: product_image3}, %{image: product_image4}]}) |> Repo.insert! end) |> Enum.to_list

