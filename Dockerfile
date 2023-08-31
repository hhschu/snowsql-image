# syntax=docker/dockerfile:1.3
FROM debian:12-slim
LABEL maintainer="David Chu (sct.chu@gmail.com)"

ARG BOOTSTRAP_VERSION
ARG VERSION

RUN apt-get update && apt-get -y install --no-install-recommends \
    curl ca-certificates unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/$BOOTSTRAP_VERSION/linux_x86_64/snowsql-$VERSION-linux_x86_64.bash \
    && SNOWSQL_DEST=/usr/bin SNOWSQL_LOGIN_SHELL=~/.profile bash snowsql-$VERSION-linux_x86_64.bash \
    && rm snowsql-$VERSION-linux_x86_64.bash

RUN useradd --create-home --uid 1001 snowsql
WORKDIR /home/snowsql
USER 1001

# The program lazy installs things at the first run
RUN snowsql
