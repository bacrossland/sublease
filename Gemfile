source 'https://rubygems.org'

ruby '>= 2.3.1'
gem 'rails', '~> 5.1'
gem 'rdoc'

gem 'shoulda', group: [:development, :test]

# Declare your gem's dependencies in sublease.gemspec
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

platforms :jruby do
  gem 'pry', group: [:development, :test]
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'byebug', group: [:development, :test]
  gem 'sqlite3'
end