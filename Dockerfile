FROM ruby:2.1

# --- FIX Debian Jessie repos (EOL) ---
RUN sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org|archive.debian.org/debian-security|g' /etc/apt/sources.list \
 && sed -i '/jessie-updates/d' /etc/apt/sources.list \
 && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Dependencias para mysql2 + compilar gems + assets
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends \
    nodejs \
    libmysqlclient-dev \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN gem install bundler -v 1.17.3 || gem install bundler
RUN bundle install

ENV RAILS_ENV=production
ENV RACK_ENV=production

EXPOSE 3000

CMD bash -lc "bundle exec rake db:create && bundle exec rake db:schema:load || true; bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"
