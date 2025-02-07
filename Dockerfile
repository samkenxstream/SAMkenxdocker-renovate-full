# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=35.110.1

# Base image
#============
FROM ghcr.io/containerbase/base:7.10.1@sha256:470a997d0093308125706a69fb9c35e4a4a7e173cecccb52c9f9fdcb0357bd6f AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.16.0

# renovate: datasource=npm versioning=npm
RUN install-tool npm 9.6.7

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.19

WORKDIR /usr/src/app

# renovate: datasource=docker versioning=docker
RUN install-tool docker 23.0.6

# renovate: datasource=adoptium-java
RUN install-tool java 17.0.7+7

# renovate: datasource=gradle-version versioning=gradle
RUN install-tool gradle 8.1.1

# renovate: datasource=github-releases lookupName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 25.3.2.1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.14.5

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 8.2.6

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.5.7

# renovate: datasource=golang-version
RUN install-tool golang 1.20.4

# renovate: datasource=github-releases lookupName=containerbase/python-prebuild
RUN install-tool python 3.11.3

# renovate: datasource=pypi
RUN install-tool pipenv 2023.6.2

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.5.1

# renovate: datasource=pypi
RUN install-tool hashin 0.17.0

# renovate: datasource=pypi
RUN install-tool pip-tools 6.13.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.70.0

# renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
RUN install-tool ruby 3.2.2

# renovate: datasource=rubygems versioning=ruby
RUN install-tool bundler 2.4.13

# renovate: datasource=rubygems versioning=ruby
RUN install-tool cocoapods 1.12.1

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 7.0.302

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 7.32.5

# renovate: datasource=npm versioning=npm
RUN install-tool lerna 6.6.2

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.12.0

# renovate: datasource=github-releases lookupName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

ENV RENOVATE_X_IGNORE_NODE_WARN=true

# exec helper
COPY bin/ /usr/local/bin/
CMD ["renovate"]

ARG RENOVATE_VERSION

RUN install-tool renovate

# Compabillity, so `config.js` can access renovate and deps
RUN ln -sf /opt/buildpack/tools/renovate/${RENOVATE_VERSION}/node_modules ./node_modules;

RUN set -ex; \
  renovate --version; \
  renovate-config-validator; \
  node -e "new require('re2')('.*').exec('test')"; \
  true

LABEL org.opencontainers.image.version="${RENOVATE_VERSION}"

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
