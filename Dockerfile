FROM ruby:2.4.1

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV APPDIR /snipe-rails
RUN mkdir $APPDIR
WORKDIR $APPDIR

ADD Gemfile $APPDIR/Gemfile
ADD Gemfile.lock $APPDIR/Gemfile.lock

RUN bundle install -j 4

ADD . $APPDIR
