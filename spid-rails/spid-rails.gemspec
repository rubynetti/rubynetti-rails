$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spid/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spid-rails"
  s.version     = Spid::Rails::VERSION
  s.authors     = ["Alessandro Descovi"]
  s.email       = ["descovi@gmail.com"]
  s.homepage    = "http://spid-regole-tecniche.readthedocs.io"
  s.summary     = "Spid for Rails"
  s.description = "Sistema Pubblico di Identità Digitale https://www.spid.gov.it/"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "ruby-saml", "~> 1.5.0"

  s.add_development_dependency "sqlite3"
end
