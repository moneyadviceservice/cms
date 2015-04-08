# CMS

The MAS CMS.

## Prerequisites

- Ruby/Rails
- ImageMagic
- MySQL
- Node.js (for Bower)
- Bower (Install via NPM)

## Installation

### Configuration

```sh
$ ./bin/setup
$ rails s
```

The setup script will install required gems, bower modules and create the databases as well as seed some data to setup the CMS.

Note: Make sure you've added all the required API keys for the app to work properly. Make sure you set the HOSTNAME, GA_API_EMAIL_ADDRESS, GA_PRIVATE_KEY_PATH variables in the `.env` file appropriately. The setup script above will set up the `.env` file  structure but you may need to set some keys seperately, particularly the Rackspace ones.

### Updating Dough

Sometimes you may need to seperately update Dough to pull the latest style changes. You can do that by running:

```sh
bundle update dough-ruby
bowndler update
```

## Testing

Run unit specs with:

```sh
$ bundle exec rspec
```

Run feature specs with:

```sh
$ bundle exec cucumber
```

For JavaScript tests we use:

- [Karma](http://karma-runner.github.io) as our test runner.
- [karma-cli](https://www.npmjs.org/package/karma-cli):

Run JavaScript tests with:

```sh
npm test
```

Or for the direct command:

```sh
./node_modules/karma/bin/karma start test/karma.conf.js
```

`autoWatch` is on by default so tests will rerun whenever changes are made.

Use `--single-run` if you only want it to run once.

## Deploying

This can easily be deployed to Heroku but the MAS organisation uses its own deploymen infranstructure. If you're a MAS employee, you can deploy this to QA by trigerring the `cms_commit` pipeline . Refer to the organisational [wiki](https://moneyadviceserviceuk.atlassian.net/wiki/display/TEAMB/Contento+CMS) on how to deploy to our production environment.

## Additional Notes

### Component Styleguide

[The styleguide](http://0.0.0.0:3000/styleguide) lists all HTML/CSS components used within the CMS.

Any new components should be built here first, then integrated into the views.

### Cron / Rake

The rake task
```bundle exec rake cms:update_page_views```

is to retrieve page views from Google Analytics for articles.
This allows us to generate the Popular links section that is displayed in the frontend application.
