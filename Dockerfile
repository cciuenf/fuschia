FROM bitwalker/alpine-elixir:latest

MAINTAINER zoedsoupe

RUN apk update \
    && apk add --no-cache tzdata ncurses-libs postgresql-client build-base \
    && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" > /etc/timezone \
    && apk del tzdata

WORKDIR /fuschia

ARG MIX_ENV=prod

RUN mix do local.hex --force, local.rebar --force

COPY mix.exs mix.lock ./
COPY config config

RUN mix do deps.get, deps.compile
RUN mix assets.deploy
RUN mix ecto.setup

COPY . ./
RUN mix compile

CMD ["iex", "-S", "mix", "phx.server"]
