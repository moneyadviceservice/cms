# CMS

The MAS CMS.

## Prerequisites

- Ruby/Rails
- ImageMagic
- MySQL
- Node.js (for Bower)
- Bower (Install via NPM)
- Access to the MAS network (so that you can bundle install the private gems)

## Installation

The same source code is used by two applications: CMS and Fincap CMS.
So the next section will explain the setup for each application.

### Environment setup (Mac OsX)

MySql needs to be installed and linked.
Make sure Homebrew is installed.

```
brew install mysql55
brew link mysql55 --force
```

### CMS setup

```sh
$ ./bin/setup
```

The setup script will install required gems, bower modules and create the databases as well as seed some data to setup the CMS.

Note: Make sure you've added all the required API keys for the app to work properly. Make sure you set the HOSTNAME, GA_API_EMAIL_ADDRESS, GA_PRIVATE_KEY_PATH variables in the `.env` file appropriately. The setup script above will set up the `.env` file  structure but you may need to set some keys seperately, particularly the Rackspace ones.

The setup script will create *three* databases: `cms_test`, `cms_mas_development`, `cms_fincap_development`
The two development databases are for the two different applications we run from this repository: MAS CMS and Fincap CMS

### Running application locally

You can run either application separately by passing the APP_NAME environment variable when running the command
```sh
$ APP_NAME='FINCAP' rails s
```
or
```sh
$ APP_NAME='MAS' rails s
```

####

To reseed the database to the initial state:
```sh
$ APP_NAME='FINCAP' bundle exec rake db:drop db:create db:schema:load db:migrate db:seed:fincap
```

```sh
$ APP_NAME='MAS' bundle exec rake db:drop db:create db:schema:load db:migrate db:seed:cms
```

### Updating Dough

Sometimes you may need to seperately update Dough to pull the latest style changes. You can do that by running:

```sh
bundle update dough-ruby
bowndler update
```

## Testing

The tests(and code) are agnostic to the applications(MAS & Fincap) however the current implementation
still requires you to pass an APP_NAME when running the tests just so everything can boot up.
It will not matter which APP_NAME you pass through here.

Run unit specs with:

```sh
$ APP_NAME='MAS' bundle exec rspec
```

Run feature specs with:

```sh
$ APP_NAME='MAS' bundle exec cucumber
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
./node_modules/karma/bin/karma start ./spec/javascripts/karma.conf.js
```

`autoWatch` is on by default so tests will rerun whenever changes are made.

Use `--single-run` if you only want it to run once.

## Hooks

This project uses git hooks to ensure every commit follows best practices.
The test script runs the code lints and the tests.

In order to use the hooks just run this commands:

```sh
  cp hooks/pre-push .git/hooks/pre-push
  chmod u+x .git/hooks/pre-push
```

If using the hook, you will have to set the `APP_NAME` ENV variable:
```sh
APP_NAME=MAS git push origin feature/my-branch
```

Note: *It is not recommended but if you want to ignore the hook, you can run*:

```
git push --no-verify origin <your_branch>
```

## Using for front-end development

When developing [the front end](https://github.com/moneyadviceservice/frontend) it is usual to point it to a locally running instance of this CMS. In this case it is useful to clone the QA database to your local database.

```sh
mysqldump -h az2-tst-qa01.dev.mas.local -u cms -p cms_qa > cms_qa.sql
mysql -u root cms_development < cms_qa.sql

```

The credentials for the QA database are kept in Keepass under "MAS QA" --> "mysql password".

Note that the database is quite large, so it may take a while.

## Deploying

This can easily be deployed to Heroku but the MAS organisation uses its own deployment infrastructure. If you're a MAS employee, you can deploy this to QA by triggering the `cms_commit` pipeline . Refer to the organisational [wiki](https://moneyadviceserviceuk.atlassian.net/wiki/display/TEAMB/Contento+CMS) on how to deploy to our production environment.

## Additional Notes

### Technical Docs
[CMS](https://github.com/moneyadviceservice/technical-docs/tree/master/cms)

We use [apipie](https://github.com/Apipie/apipie-rails) to document the cms api. Once you've set up the project and started a server, you can view the docs by visiting `http://localhost:3000/apipie`

### Component Styleguide

[The styleguide](http://0.0.0.0:3000/styleguide) lists all HTML/CSS components used within the CMS.

Any new components should be built here first, then integrated into the views.

### Cron / Rake

The rake task
```bundle exec rake cms:update_page_views```

is to retrieve page views from Google Analytics for articles.
This allows us to generate the Popular links section that is displayed in the frontend application.
