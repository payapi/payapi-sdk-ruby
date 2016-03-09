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

Payment
```ruby
# Configure in an initializer.
require 'payapi'
params = {
  site: 'input.payapi.io',
  key: '[YOUR API KEY]',
  password: '[YOUR API KEY'S PASSWORD]',
  secret: '[YOUR API KEY'S SECRET]'
}
PayApi.configure params

# Process a payment
payment_params = {
  payment: {
    cardHolderEmail: "cardholder@example.com",
    cardHolderName: "John Smith",
    paymentMethod: "mastercard",
    creditCardNumber: "4242 4242 4242 4242",
    ccv: "1234",
    expiresMonth: "2",
    expiresYear: "3016",
    locale: "en-US",
    ip: "::ffff:127.0.0.1"
  },
  consumer: {
    name: "John Smith",
    co: "",
    streetAddress: "Delivery street 123",
    streetAddress2: "",
    postalCode: "90210",
    city: "New York",
    stateOrProvince: "",
    country: "USA"
  },
  order: {
    sumInCentsIncVat: 322,
    sumInCentsExcVat: 300,
    vatInCents: 22,
    currency: "EUR",
    referenceId: "ref123",
    sumIncludingVat: "€3.22",
    sumExcludingVat: "€3.00",
    vat: "€0.22"
  },
  products: [
    {
      id: "bbc123456",
      quantity: 1,
      title: "Black bling cap",
      description: "Flashy fine cap",
      imageUrl: "https://example.com/black_bling_cap.png",
      category: "Caps and hats",
      priceInCentsIncVat: 122,
      priceInCentsExcVat: 100,
      vatInCents: 22,
      vatPercentage: "22%",
      priceIncludingVat: "€1.22",
      priceExcludingVat: "€1.00",
      vat: "€0.22"
    },
    {
      id: "pbc123456",
      quantity: 1,
      title: "Pink bling cap",
      description: "Flashy fine cap",
      imageUrl: "https://example.com/pink_bling_cap.png",
      category: "Caps and hats",
      priceInCentsIncVat: 222,
      priceInCentsExcVat: 200,
      vatInCents: 22,
      vatPercentage: "22%",
      priceIncludingVat: "€2.22",
      priceExcludingVat: "€2.00",
      vat: "€0.22"
    }
  ],
  callbacks: {
    success: "https://merchantserver.xyz/payments/success",
    failed: "https://merchantserver.xyz/payments/failed",
    chargeback: "https://merchantserver.xyz/payments/chargeback"
  }
};
PayApi::Payment.new(payment_params).call
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
