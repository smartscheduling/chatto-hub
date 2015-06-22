## Chatto Hub

### Set Up
*  Using Ruby 2.1.5
*  Postgresql
*  RSpec/Capybara

```
rake db:create
rake db:migrate
rake db:test:prepare
rspec spec
```

Environment Variables:
```
GITHUB_APP_ID=
GITHUB_APP_SECRET=
SLACK_TOKEN=
```

### TODO:
* have channel_id saved to the project so I don't have to make another API request

