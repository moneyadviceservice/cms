FROM ruby:2.7.7

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm imagemagick

RUN mkdir /myapp
WORKDIR /myapp

ENV BUNDLE_GEM__FURY__IO=7LFoF-x9YJoqOoGxi84i6BCDfxDvRt0
ENV APP_NAME=FINCAP
ENV RAILS_ENV=production
ENV RAILS_GROUPS=assets
ENV FINCAP_ALGOLIA_APP_ID=$ALGOLIA_APP_ID
ENV FINCAP_ALGOLIA_API_KEY=$ALGOLIA_API_KEY

COPY Gemfile* .ruby-version package.json ./

RUN gem install bundler:1.17.3
RUN bundle install -j4

RUN npm install -g bower@1.8.8

COPY . /myapp

RUN rm -rf vendor/assets/bower_components
RUN bundle exec bowndler update --allow-root
RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["puma"]
