FROM ruby:4.0.0

# sanity deps for Rails
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  nodejs \
  npm \
  git \
  sqlite3 \
  libsqlite3-dev

WORKDIR /app
