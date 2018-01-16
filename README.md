# Sublease

Sublease is a tenanting engine for Rails 4.1 and greater applications using a shared database or schema.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sublease'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sublease

## Usage

Simple version. Data is immutable unless attrib for overriding is set.
      
Tenant Model has_many_subleases(:lodger)
Lodger Model sublease_belongs_to (:tenant)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sublease. All pull requests should be against the 
development branch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sublease project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sublease/blob/master/CODE_OF_CONDUCT.md).
