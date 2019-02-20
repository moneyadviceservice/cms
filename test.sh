#!/bin/bash -l

set -e

export PATH=./bin:$PATH
export RAILS_ENV=test
export BUNDLE_WITHOUT=development
# Workaround to remove ::Fixnum warnings until Rails upgrade
export RUBYOPT=-W0

CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
BUNDLE_JOBS=$((CORES-1))

# remove prior dirty packaged gems e.g. build.sh
rm -rf vendor/cache .bundle/config

bundle install --jobs $BUNDLE_JOBS
npm install

bundle exec bowndler install

if [ -n "$GO_PIPELINE_NAME" ]; then
  cp config/database{-ci,}.yml

  rake db:drop db:create db:schema:load db:migrate
fi

CI_PIPELINE_COUNTER=${GO_PIPELINE_COUNTER-0}
CI_EXECUTOR_NUMBER=${EXECUTOR_NUMBER-0}

bundle exec rspec spec --format html --out tmp/spec.html --format RspecJunitFormatter --out tmp/spec.xml --format progress --profile --deprecation-out log/rspec_deprecations.txt
bundle exec cucumber
bundle exec rubocop
./node_modules/karma/bin/karma start spec/javascripts/karma.conf.js --single-run
