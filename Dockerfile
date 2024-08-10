# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails-app

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    default-mysql-client \
    libjemalloc2 \
    libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    PATH="/rails-app/bin:${PATH}"

FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    default-libmysqlclient-dev \
    git \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config set frozen false && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy the rest of the application code
COPY . .

RUN bundle exec bootsnap precompile app/ lib/

FROM base

# Copy the built application from the build stage
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails-app /rails-app

# Create a user and set permissions
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails-app/db /rails-app/log /rails-app/storage /rails-app/tmp
USER 1000:1000

ENTRYPOINT ["./bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
