## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hyperwallet-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hyperwallet-rails

## Usage

#### Set API user/pass

Create an initializer with the content:

```
Hyperwallet.api_user = ENV['HYPERWALLERT_API_USER']
Hyperwallet.api_password = ENV['HYPERWALLERT_API_PASS']
Hyperwallet.api_base = ENV['HYPERWALLET_API_BASE']
```

## Managing Users

To create a user:

```
Hyperwallet::User.create({valid: user_data})
```

To find a user:

```
Hyperwallet::User.find(user_key_id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Devato/hyperwallet-rails.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

