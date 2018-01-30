[![Build Status](https://travis-ci.org/bacrossland/sublease.svg?branch=master)](https://travis-ci.org/bacrossland/sublease)

# Sublease

Sublease is a tenanting engine for Rails 4.2 and greater applications using a shared database or schema. It's a Rails Engine 
designed to be lightweight, simple to implement, and easy to use. Sublease works with existing as well as new applications.

## Ruby Versions

The following Ruby MRI and jRuby versions or greater are supported. Sublease was not built for or tested against other versions.

Ruby >= 2.3.1
jRuby >= 9.1.8.0

## Rails Versions

Sublease is built and tested to run using Rails version 4.2 or greater. While Sublease will run on Rails 4.1.16, it is not officially supported.

## Installation

1. On the model that you want tenanted, add the fields 'domain' and 'subdomain' through a migration. Both of these fields should be strings.

1. Add this line to your application's Gemfile:

        gem 'sublease'
        
    And then execute:
        
        $ bundle install
        
    Or install it yourself as:
        
        $ gem install sublease

1. Finally, install the Sublease configuration file. This will add config/initializers/sublease.rb to you application.


         $ rails generate sublease:install



## Usage

### Models

Sublease works by create controlled has_many and belongs_to relationships between your tenant and any other model. The has_many_subleases 
model should inherit from Sublease::Tenant and the belongs_to_subleases model should inherit from Sublease::Lodger. For 
instance, if your application allowed for accounts to be created that would be shared by many users, your models would 
look like this:
 
    class Account < Sublease::Tenant
      has_many_subleases(:users)
    end
    
    class User < Sublease::Lodger
      belongs_to_sublease(:account)
    end

The relationships work just like normal has_many and belongs_to ActiveRecord Relationships even taking the same options. 
The difference is that the relationship is immutable and all dependencies on the relationship are overridden to call 
the destroy method. This is to ensure that all callback are called on the model in the event of a delete or destroy method call.

#### Scoping For Unique Records

When adding unique record scope on your model, just do it as you would normally in ActiveRecord. Sublease is designed to 
be simple and not replace things that Rails and ActiveRecord can do just fine. Using the example above, if you wanted to 
scope a user's email to be unique per account, you might add a validator like so:

    class User < Sublease::Lodger
      belongs_to_sublease(:account)
      
      validates :email, presence: true, uniqueness: { case_sensitive: false, scope: :account_id }
    end

#### Moving Tenants

In most cases, once a record is tenanted it stays with it's tenant. Sublease prevents switching tenants by default. 
However, sometimes it is necessary to move a record from one tenant to another. To do this set the allow_sublease_change 
property to true. Using the example above, we'll move user 1 from account 1 to account 2.

    $ user = User.find 1
    $ user.allow_sublease_change = true
    $ user.account_id = 2
    $ user.save

### Controllers

Sublease can change your tenant on the fly based on a requests subdomain, domain, or both. This switching is handled in 
any controller you want by including Sublease::TenantSwitcher. In the example below, we include it into ApplicationController 
which means that every controller in the application will check the request to make sure the correct tenant is set. 
You might not want every request to a controller checking to set the tenant so make sure you only add it to the controllers
that need it.

    class ApplicationController < ActionController::Base
      
      include Sublease::TenantSwitcher
    end

The current tenant can be accessed from `Sublease.current_tenant`. Use this to set the tenant for new records or even to 
show records belonging to that tenant.


## Configuration

Sublease can be configured to set a default subdomain and/or domain. It can also be configured to determine by which method 
to switch the tenant: subdomain, domain, or subdomain and domain. See config/initializers/sublease.rb for all options.


## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bacrossland/sublease. All pull requests should be against the 
development branch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sublease project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sublease/blob/master/CODE_OF_CONDUCT.md).
