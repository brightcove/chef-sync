chef-sync
=========

Synchronize Chef nodes w/ Capistrano and other config

## Installation

Add this line to your application's Gemfile:

    gem 'chef-sync'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-sync

## Usage

    $ > chef-sync
    $ Target: ../katama_server
    $ ----------------------------------------------------------
    $ - Synchronizing Cap config/stages.yml w/ Chef Node Set
    $ ----------------------------------------------------------
    $ - production/app web ...
    $ - production/resque ...
    $ - qa/app web ...
    $ - qa/resque ...
    $ - staging/app web ...
    $ - staging/resque ...
    $ ----------------------------------------------------------
    $ - Synchronizing config/mongo.yml w/ Chef Node Set
    $ ----------------------------------------------------------
    $ - qa...
    $ - staging...
    $ - production...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
