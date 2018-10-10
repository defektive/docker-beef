FROM ruby:2.3-slim
LABEL maintainer "defektive <github.com/defektive>"

ENV LANG C.UTF-8 \
    DEPS build-essential \
         git \
         libsqlite3-dev \
         apt-transport-https \
         ca-certificates \
         curl \
         gnupg2

RUN apt-get update \
  && apt-get install -y \
    $DEPS \
    sqlite3 \
    \
  && useradd -m beef \
  \
  && git clone --depth=1 \
    --branch=master \
    https://github.com/defektive/beef.git \
    /home/beef/beef \
    \
  && cd /home/beef/beef \
  && gem install rake \
  && bundle add mini_racer \
  && bundle install --without test development \
  \
  && chown -R beef /home/beef/beef \
  \
  && rm -rf /home/beef/beef/.git \
  && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && curl -sL https://deb.nodesource.com/setup_6.x | bash -\
  && apt-get install -y \
    nodejs \
    yarn \
  && apt-get purge -y $DEPS \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/beef/beef

VOLUME /home/beef/.beef

USER beef

EXPOSE 3000 6789 61985 61986

COPY entrypoint.sh /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
