## Chatto Hub
[![Code Climate](https://codeclimate.com/github/smartscheduling/chatto-hub/badges/gpa.svg)](https://codeclimate.com/github/smartscheduling/chatto-hub)
[![Coverage Status](https://coveralls.io/repos/smartscheduling/chatto-hub/badge.svg?branch=master&service=github)](https://coveralls.io/github/smartscheduling/chatto-hub?branch=master)
[![Build Status](https://travis-ci.org/smartscheduling/chatto-hub.svg?branch=badges)](https://travis-ci.org/smartscheduling/chatto-hub)

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

The MIT License (MIT)

Copyright (c) 2015 Smart Scheduling, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
