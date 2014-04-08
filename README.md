# Addons gem test

## Integrating with Addons is Simple

* add `gem 'addons', '~> 0.0.7'` to your Gemfile
* `bundle install` installs figaro
* `rails generate addons:install --appid:'app_97308f3f-948a-4f90-879a-ea3155e5f6d7' --apptoken='pyw5WBzdfFBh5ta5K63g'` NOTE: Use your own APP_ID AND APP_TOKEN
* SIGN UP FOR ADDONS LAUNCHBOX
* set `ENV['ADDONS_APP_ID']` and `ENV['ADDONS_APP_TOKEN']` environment variables
* `rails console` or `rails server` will have set all environment variables and create a config/application.yml
* HEROKU USERS ONLY: `rake figaro:heroku` will set all your heroku environment variables
* Add code to integrate with your services. All environment variables for those services are securely populated by the Addons gem

### Mailgun Integration

```ruby
def send_simple_message(email)
  RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}"\
  "@api.mailgun.net/v2/sandbox28428.mailgun.org/messages",
  :from => email.from,
  :to => email.to,
  :subject => email.subject,
  :text => email.body
end
````

### MongoLab Integration #1

add mongoid to Gemfile
```ruby
gem 'mongoid', github: 'mongoid/mongoid'
```

run bundle install in Terminal
```shell
bundle install
```

Add production config to config/mongoid.yml
````ruby
production:
  sessions:
    default:
      uri: <%= ENV['MONGOLAB_URI'] %>
      options:
        max_retries: 30
        retry_interval: 1
        timeout: 15
````

Add Mongoid config to a model (app/models/email.rb)
```ruby
class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, type: string
  field :from, type: String
  field :subject, type: String
  field :body, type: String
end

```

Change config/application.rb
```ruby
# MONGOID CONFIG
#require 'rails/all'
require "action_controller/railtie"
require "action_mailer/railtie"
# require "active_resource/railtie"
require "sprockets/railtie"
```

### MongoLab Integration #2

* add `gem 'mongo'` and `gem 'bson_ext'` to Gemfile
* `bundle install`
* add a test script to print collection names to `scripts/mongoLabTest.rb`
* run test, `rails console`, `require './scripts/mongoLabTest'`, `Test::MongoLab.run()`

````ruby
require 'mongo'
include Mongo

module Test
  class MongoLab
    def self.run
      mongo_uri = ENV['MONGOLAB_URI']
      db_name = mongo_uri[%r{/([^/\?]+)(\?|$)}, 1]
      client = MongoClient.from_uri(mongo_uri)
      db = client.db(db_name)
      db.collection_names.each { |name| puts name }
    end
  end
end
````
