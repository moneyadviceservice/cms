#!/bin/bash -l

set -e

unset RUBYOPT
export BUNDLE_WITHOUT="test:development"

version_number=${GO_PIPELINE_LABEL-0}
revision=`git rev-parse HEAD`
build_date=`date +'%Y-%m-%d %H:%M %z'`

cat > public/version <<EOT
{
  "version":"$version_number",
  "buildDate":"$build_date",
  "gitRevision":"$revision"
}
EOT

echo "Cleaning temporary files"
echo "----"
rm -rf public/assets vendor/cache coverage log/* tmp/* .bundle/config

echo "Configuring credentials for Rails LTS"
echo "----"
bundle config gems.railslts.com RAILS_LTS_USERNAME:RAILS_LTS_PASSWORD

echo "Running Bundle package"
echo "----"
bundle package --all

echo "Running Bower cache clean"
echo "----"
bower cache clean

echo "Running Bower update (via bowndler)"
echo "----"
bowndler update --production --config.interactive=false

echo "Precompiling assets"
echo "----"
RAILS_ENV=production RAILS_GROUPS=assets rake assets:precompile
cp vendor/assets/bower_components/components-font-awesome/fonts/fontawesome-webfont.woff public/assets/components-font-awesome/fonts/
cp vendor/assets/bower_components/components-font-awesome/fonts/fontawesome-webfont.ttf public/assets/components-font-awesome/fonts/

echo "Creating RPM"
echo "----"
cd ..
/usr/local/rpm_builder/create-rails-rpm $artifact_name $artifact_name $version_number

#prune packaged gems
rm -rf vendor/cache
