# omniauth_uoc

The omniauth_uoc library is an OmniAuth provider that supports authentication against UOC REST apis

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth', '~> 1.0'
    gem 'omniauth_uoc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth_uoc

## Usage

You will need to configure OmniAuth to use your uoc authentication.  This is generally done in Rails in the config/initializers/omniauth.rb with:

    Rails.application.config.middleware.use OmniAuth::Builder do
        provider :uoc, :uoc_server_url=>"https://cv.uoc.edu/"
    end

## References

 * OmniAuth: https://github.com/intridea/omniauth/
 * Especially thanks to [Rob Di Marco](https://github.com/robdimarco) and his [omniauth_crowd](https://github.com/robdimarco/omniauth_crowd) project that it was inspiration for me.

## Contributing

1. Fork it ( https://github.com/UOC/omniauth_uoc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014 Universitat Oberta de Catalunya. See LICENSE.txt for further details.

