require 'rest-client'
require 'jwt'
module PayApi

  class Payment
    attr_reader :params, :data
    #params = {
    #  payment: {
    #    cardHolderEmail: "cardholder@example.com",
    #    cardHolderName: "John Smith",
    #    paymentMethod: "mastercard",
    #    creditCardNumber: "4242 4242 4242 4242",
    #    ccv: "1234",
    #    expiresMonth: "2",
    #    expiresYear: "3016",
    #    locale: "en-US",
    #    ip: "::ffff:127.0.0.1"
    #  },
    #  consumer: {
    #    name: "John Smith",
    #    co: "",
    #    streetAddress: "Delivery street 123",
    #    streetAddress2: "",
    #    postalCode: "90210",
    #    city: "New York",
    #    stateOrProvince: "",
    #    country: "USA"
    #  },
    #  order: {
    #    sumInCentsIncVat: 322,
    #    sumInCentsExcVat: 300,
    #    vatInCents: 22,
    #    currency: "EUR",
    #    referenceId: "ref123",
    #    sumIncludingVat: "€3.22",
    #    sumExcludingVat: "€3.00",
    #    vat: "€0.22"
    #  },
    #  products: [
    #    {
    #      id: "bbc123456",
    #      quantity: 1,
    #      title: "Black bling cap",
    #      description: "Flashy fine cap",
    #      imageUrl: "https://example.com/black_bling_cap.png",
    #      category: "Caps and hats",
    #      priceInCentsIncVat: 122,
    #      priceInCentsExcVat: 100,
    #      vatInCents: 22,
    #      vatPercentage: "22%",
    #      priceIncludingVat: "€1.22",
    #      priceExcludingVat: "€1.00",
    #      vat: "€0.22"
    #    },
    #    {
    #      id: "pbc123456",
    #      quantity: 1,
    #      title: "Pink bling cap",
    #      description: "Flashy fine cap",
    #      imageUrl: "https://example.com/pink_bling_cap.png",
    #      category: "Caps and hats",
    #      priceInCentsIncVat: 222,
    #      priceInCentsExcVat: 200,
    #      vatInCents: 22,
    #      vatPercentage: "22%",
    #      priceIncludingVat: "€2.22",
    #      priceExcludingVat: "€2.00",
    #      vat: "€0.22"
    #    }
    #  ],
    #  callbacks: {
    #    success: "https://merchantserver.xyz/payments/success",
    #    failed: "https://merchantserver.xyz/payments/failed",
    #    chargeback: "https://merchantserver.xyz/payments/chargeback"
    #  }
    #};

    def initialize(params)
      @params = params
      @data = params[:data]
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def payload
      payload = {
        authenticationToken: Authenticate.new.call,
        paymentToken: JWT.encode(data, CONFIG[:secret], 'HS512')
      }.to_json
    end

    def call
      resource = RestClient::Resource.new(
        CONFIG[:site],
        {
          read_timeout: CONFIG[:read_timeout],
          open_timeout: CONFIG[:open_timeout],
          headers: {content_type: :json, accept: :json }
        })
      puts "******************** payload"
      puts payload
      puts "******************** /payload"
      response = resource['/v1/api/authorized/payments'].post payload
      puts "******************** response"
      puts response
      puts "******************** /response"
    end
  end
end

