# DropAlley

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Add admin and api endpoint together

* Step 1: Generate admin pages
mix torch.gen.html ChannelPartner Bucket buckets state:string partner_id:references:partners product_id:references:products active:boolean assigned_time:naive_datetime pickup_time:naive_datetime pick_up_location:map drop_time:naive_datetime drop_location:map

* Step 2: Generate API end-points
mix phx.gen.json ChannelPartner Bucket buckets state:string partner_id:references:partners product_id:references:products active:boolean assigned_time:naive_datetime pickup_time:naive_datetime pick_up_location:map drop_time:naive_datetime drop_location:map --web API.V1 --no-schema --no-context

* Step 3: Add routes
    resources "/buckets", BucketController
    in both :browser as well as :api plug routes
    scope "/api/v1", DropAlleyWeb.API.V1 do
      pipe_through :api
      ...
      resources "/buckets", BucketController
    end

* Step 4: Add Link in torch.html.eex
    <nav class="torch-nav">
      <!-- nav links here -->
      ...
      <a href="/admin/buckets">Bucket</a>
    </nav>

* Step 5: Remove put_resp_herader from API.V1.BucketController, create action
     |> put_resp_header("location", api_v1_bucket_path(conn, :show, bucket))

* Step 6: Replace all Routes.bucket_path with DropAlleyWeb.Router.Helpers.bucket_path in entire directory -> replace_all

* Step 7: Add association in module if required

* Step 8: mix ecto.migrate

* Step 9: mix phx.server

* Step 10: Now both browser and api end point is available
    http://localhost:4000/admin/buckets
    http://localhost:4000/api/v1/buckets