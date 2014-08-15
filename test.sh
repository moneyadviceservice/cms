#!/bin/bash -l

set -e

export PATH=./bin:$PATH
export RAILS_ENV=test
export BUNDLE_WITHOUT=development


if [ -n "$GO_PIPELINE_NAME" ]; then
  cp config/database{-ci,}.yml

  rake app:db:drop app:db:create app:db:schema:load app:db:migrate
fi

CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
BUNDLE_JOBS=$((CORES-1))

CI_PIPELINE_COUNTER=${GO_PIPELINE_COUNTER-0}
CI_EXECUTOR_NUMBER=${EXECUTOR_NUMBER-0}

bundle install --jobs $BUNDLE_JOBS

rake spec
rake cucumber
npm test
