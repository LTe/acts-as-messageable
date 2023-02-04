ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

WORKDIR /home/app

COPY Gemfile Gemfile.lock gemfiles ./

ARG GEMFILE
ENV BUNDLE_GEMFILE=${GEMFILE}
RUN gem install bundler 
RUN bundle install

CMD ["bundle", "exec", "rake"]

