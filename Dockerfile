FROM hexpm/elixir:1.13.4-erlang-24.3.3-alpine-3.14.5 AS build
RUN apk add --no-cache build-base git curl inotify-tools

# sets work directory
WORKDIR /app

ARG MIX_ENV
ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
# install hex package manager
RUN mix local.hex --force && mix local.rebar --force

# copy code base from local to container
COPY . ./

# copy mix packages to the container
COPY mix.exs mix.lock ./

# fetch and install the project dependencies
RUN mix deps.get --only ${MIX_ENV}

# compile dependencies
RUN mix deps.compile

# Compile assets
RUN mix assets.deploy

#compile projects
RUN mix compile

# assemble release
RUN mix release


FROM build AS app

ARG MIX_ENV
ARG user=codebox
ARG group=codebox
ARG uid=1000
ARG gid=1001

WORKDIR /app

RUN apk add --no-cache libstdc++ openssl ncurses-libs inotify-tools build-base git curl

# add user codebox and group with respective ids
RUN addgroup -g ${gid} ${group}
RUN adduser -u ${uid} -g ${group} -s /bin/sh -S ${user}

# project compiled and release to the directory
# /app/_build/"${MIX_ENV}"/rel/codebox
# copy from the build directory into the app container
COPY --from=build --chown="${user}":"${group}" /app/_build/"${MIX_ENV}"/rel/codebox ./

EXPOSE 4000
# points to bin/codebox release
ENTRYPOINT ["bin/codebox"]
# pass the PHX_SERVER to start up the server
ENV PHX_SERVER=true

# start to run the codebox app
CMD ["start"]


#CMD ["mix", "phx.server"]


# makemigrations and migrate to the db
#RUN mix ecto.create #&& mix ecto.migrate

