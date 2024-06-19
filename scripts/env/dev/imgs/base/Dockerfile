FROM erlang:26.2.5 AS erlang
FROM elixir:1.16-otp-26 AS elixir
FROM rust:1.78.0-bookworm AS rust
FROM debian:12.5

LABEL author="Maxim Molchanov"
LABEL maintainer="m.molchanov@vonmo.com"
LABEL version="3.0"
LABEL description="Base docker image for ex_rock"

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=erlang /usr/local/lib/erlang /usr/local/lib/erlang
ENV PATH=/usr/local/lib/erlang/bin:$PATH

COPY --from=elixir /usr/local/lib/elixir /usr/local/lib/elixir
ENV PATH=/usr/local/lib/elixir/bin:$PATH

COPY --from=rust /usr/local/rustup /usr/local/rustup
COPY --from=rust /usr/local/cargo /usr/local/cargo

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    LANG=C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    build-essential \
    git \
    openssl \
    libssl-dev \
    libncurses5 \
    libncurses5-dev \
    xsltproc \
    automake \
    autoconf \
    clang \
    libclang-dev \
    procps \
    python3-full \
    python3-pip \
    make \
    cmake \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists /var/cache/apt \
    && find /usr/local -name examples | xargs rm -rf

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
 && locale-gen en_US.UTF-8

ADD ./docker-entry.sh /docker-entry.sh

WORKDIR /project

CMD ["/docker-entry.sh"]
