##SyndicatePlusApi-Ruby

####Summary
The SyndicatePlus API is a platform that allows you to connect to the SyndicatePlus database for consumer product information. The main API is the SyndicatePlus Products API which allows you to search and get information on products, brands, categories and manufacturers.

####Api Access
For API access please visit the [SyndicatePlus Developer Portal][1] and [sign up][2] for an API key.

[1]: http://syndicateplus.com/developer-api/
[2]: http://syndicateplus.com/api-signup/

##Usage
Usage of the Products API is best illustrated by taking a look at the [examples][3]. To get started quickly, however, all you need to make a successful call to the SyndicatePlus API is the following code:

## Installation

Add this line to your application's Gemfile:

    gem 'SyndicatePlusApi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install SyndicatePlusApi

## Configuration

Rails style initializer (config/initializers/syndicatePlusApi.rb):

       SyndicatePlusApi::Configuration.configure do |config|
          config.secret  = 'your-secret'
          config.key     = 'your-key'
          config.version = 'your-version'
        end

## Usage
SyndicatePlusApi is designed as a module, so you can include it into any object you like:

    # require and include
    require 'SyndicatePlusApi'
    include SyndicatePlusApi::Client


But you can also use the *instance* method to get a proxy-object:

    # just require
    require 'SyndicatePlusApi'
    
    # create an SyndicatePlusApi client
    client = SyndicatePlusApi::Client.instance
    
    # lookup an result with the Porudct Id (SyndicatePlusApi)
    result = client.getProductById '5798'
    
    # have a look at the name of the result
     result.Name
     => "Unox"

    # search for any kind of product on syndicatePlus with keywords
    results = search_product('Unox')
    results.first.Name
    => "Activia"

    # search product on syndicatePlus with Ean
    result = getProductByEan 8711200189106
    result.Name
    => "Unox"

## Cache
To enable caching, set the `config.cache` key in this gem's configuration to a
cache store that supports `read()` and `write()` like `ActiveSupport::Cache::Store`.
The default expiration time is 4 days, but you can modify that by setting the
`config.cache_expires_in` configuration key.

## Contributions
1. Fork it ( http://github.com/<my-github-username>/SyndicatePlusApi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
