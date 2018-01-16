$:.push File.expand_path("../lib", __FILE__)

require "sublease/version"

Gem::Specification.new do |s|
  s.name          = "sublease"
  s.version       = Sublease::VERSION
  s.authors       = ["bacrossland"]
  s.email         = ["bacrossland@gmail.com"]

  s.summary       = %q{Sublease is a tenanting engine for Rails apps using a shared database or schema.}
  s.description   = %q{Sublease is a tenanting engine for Rails 4.1 and greater applications using a shared database or schema.}
  s.homepage      = "https://github.com/bacrossland/sublease"
  s.license       = "MIT"

  s.files = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "rails", "~> 4.1", '< 6.0'

  s.add_runtime_dependency('request_store', '>= 1.4.0')

  s.add_development_dependency "sqlite3"
end
