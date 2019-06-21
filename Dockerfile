FROM elixir:1.7.4-alpine

RUN apk update && apk add inotify-tools postgresql-dev make 

WORKDIR /app

COPY mix* ./
RUN mix local.hex --force 
RUN mix local.rebar --force 
RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get 
RUN mix compile
CMD ["mix", "ecto.create"]
CMD ["mix", "ecto.migrate"]
CMD ["mix", "phoenix.digest"]
# COPY . .

# EXPOSE 8000
# HEALTHCHECK CMD wget -q -O /dev/null http://localhost:8000/healthy || exit 1



CMD ["mix", "phx.server"]
