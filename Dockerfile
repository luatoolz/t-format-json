# syntax=docker/dockerfile:1

FROM alpine AS builder

RUN apk update && apk upgrade
RUN apk add --no-cache \
  ca-certificates curl wget openssl openssl-dev \
  build-base gcc git make cmake \
	luajit lua-dev lua5.1 \
	luarocks

RUN rm -f /usr/bin/lua && ln -s /usr/bin/luajit /usr/bin/lua && \
    ln -s /usr/bin/luarocks-5.1 /usr/bin/luarocks && \
    sed -i 's/lua5.1/luajit/g' `which luarocks` && \
    luarocks config lua_dir /usr && \
    sed -i 's/lua5.1/luajit/g' /root/.luarocks/config-5.1.lua  

FROM builder AS soft
RUN luarocks install --dev t-format-json

FROM scratch
COPY --from=soft / /
