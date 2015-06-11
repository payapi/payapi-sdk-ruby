# PayApi

A ruby client library for http://payapi.io/. Runtime depends on

* https://github.com/rest-client/rest-client
* https://github.com/progrium/ruby-jwt

Check gemspec for development dependencies.

## Quick PoC

Gemfile
```ruby
source 'https://rubygems.org'
gem 'payapi', git: 'https://github.com/payapi/ruby'
gem 'pry'
```

Execute
```ruby
bundle
bundle exec pry
```

Authenticate
```ruby
require 'payapi'
params = {
  site: 'input.payapi.io',
  key: [YOUR API KEY],
  password: [YOUR API KEY'S PASSWORD],
  secret: [YOUR API KEY'S SECRET]
}
token = PayApi::Authenticate.new(params).call
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payapi', git: 'https://github.com/payapi/ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install payapi

## Usage

Create an account at http://input.payapi.io/ or its staging site, which can be used for integration development. Set the password for your subscription's API key you are going to use. Then copy the following parameters into your application:

* ApiKey key
* ApiKey secret
* ApiKey password
* Site (input.payapi.io or its staging site)

We recommend using something like [dotenv](https://github.com/bkeepers/dotenv/ "dotenv") in combination with [settingslogic](https://github.com/binarylogic/settingslogic/ "settingslogic") to inject the values into your application and/or stage.

In order to use the non-free endpoints you will need a token. You can request the token through authentication.

```ruby
require 'payapi'
params = {
  site: Settings.payapi.site,
  key: Settings.payapi.api_key,
  password: Settings.payapi.password,
  secret: Settings.payapi.secret
}
token = PayApi::Authenticate.new(params).call
```

Store the token in your application and implement a re-authorization process based on the expiration time of the token or error handling.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec pry` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/payapi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
