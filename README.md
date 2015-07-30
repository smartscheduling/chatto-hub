## Chatto Hub
[![Code Climate](https://codeclimate.com/github/smartscheduling/chatto-hub/badges/gpa.svg)](https://codeclimate.com/github/smartscheduling/chatto-hub)
[![Coverage Status](https://coveralls.io/repos/smartscheduling/chatto-hub/badge.svg?branch=master&service=github)](https://coveralls.io/github/smartscheduling/chatto-hub?branch=master)

Chatto Hub is a tool for the [Mimic Critial
Datathon](http://criticaldata.mit.edu/) to help developers in the
event to be more efficient.

## Development
If you'd like to contribute to the project:

### Set Up
*  Using Ruby 2.1.5
*  PostgreSQL
*  RSpec/Capybara for testing
*  Follow Hound comments for style guide

```
rake db:create
rake db:migrate
rake db:test:prepare
rspec spec
```

[Required Environment Variables](https://github.com/smartscheduling/chatto-hub/blob/master/.env.example)

