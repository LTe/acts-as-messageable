ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

WORKDIR /home/app

COPY Gemfile Gemfile.lock ./
COPY gemfiles ./gemfiles/

ENV BUNDLE_PATH=/usr/local/bundle
ARG GEMFILE=Gemfile
ENV BUNDLE_GEMFILE=${GEMFILE}
RUN gem install bundler
RUN bundle install

CMD ["bundle", "exec", "rake"]

