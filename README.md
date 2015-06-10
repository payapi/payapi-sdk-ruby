# Payapi

A ruby client library for http://payapi.io/. Runtime depends on

* https://github.com/rest-client/rest-client
* https://github.com/progrium/ruby-jwt

Check gemspec for development dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payapi'
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

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec pry` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/payapi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
