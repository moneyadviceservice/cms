# CMS

The MAS CMS.

## Install dependencies

```sh
npm install
bower install
```

## Configuration
Make sure you set the HOSTNAME variable in the `.env` file appropriately.

## JavaScript testing

We use [Karma](http://karma-runner.github.io) as our test runner.

With [karma-cli](https://www.npmjs.org/package/karma-cli):

```sh
karma start test/karma.conf.js
```

Without karma-cli:

```sh
./node_modules/karma/bin/karma start test/karma.conf.js
```

`autoWatch` is on by default so tests will rerun whenever changes are made.

Use `--single-run` if you only want it to run once.
>>>>>>> Add Karma and failing test
