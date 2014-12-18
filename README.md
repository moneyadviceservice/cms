# CMS

The MAS CMS.

## Installing front-end dependencies

```sh
npm install
bowndler install
```

## Updating Dough

```sh
bundle update dough-ruby
bowndler update
```

## Configuration
Make sure you set the HOSTNAME, GA_API_EMAIL_ADDRESS, GA_PRIVATE_KEY_PATH variables in the `.env` file appropriately.

## JavaScript testing

We use [Karma](http://karma-runner.github.io) as our test runner.

With [karma-cli](https://www.npmjs.org/package/karma-cli):

```sh
npm test
```

Or for the direct command:

```sh
./node_modules/karma/bin/karma start test/karma.conf.js
```

`autoWatch` is on by default so tests will rerun whenever changes are made.

Use `--single-run` if you only want it to run once.

## Component Styleguide

[The styleguide](http://0.0.0.0:3000/styleguide) lists all HTML/CSS components used within the CMS.

Any new components should be built here first, then integrated into the views.

## Environment variables

    cp .env.dev .env

## Cron / Rake

The rake task
```bundle exec rake cms:update_page_views```

is to retrieve page views from Google Analytics for articles.
This allows us to generate the Popular links section that is displayed in the frontend application.

The rake task is setup by whenever in config/schedule.rb