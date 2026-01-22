FROM ruby:2.1

RUN apt-get update -y && apt-get install -y \
  nodejs \
  libmysqlclient-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN gem install bundler -v 1.17.3 || gem install bundler
RUN bundle install

ENV RAILS_ENV=production
ENV RACK_ENV=production

EXPOSE 3000

CMD bash -lc "bundle exec rake db:create && bundle exec rake db:schema:load || true; bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"
