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
Make sure you set the HOSTNAME variable in the `.env` file appropriately.

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
