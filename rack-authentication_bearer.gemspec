#!/usr/bin/env ruby

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/authentication_bearer/version"

Gem::Specification.new do |spec|
  spec.name = "rack-authentication_bearer"
  spec.version = Rack::AuthenticationBearer::VERSION
  spec.authors = ["Kurtis Rainbolt-Greene <kurtis@rainbolt-greene.online>"]
  spec.summary = %q{Middleware for handling Bearer type Authentication}
  spec.description = spec.summary
  spec.homepage = "https://github.com/krainboltgreene/rack-authentication_bearer.rb"
  spec.license = "MIT"

  spec.files = Dir[File.join("lib", "**", "*")]
  spec.executables = Dir[File.join("bin", "**", "*")].map { |f| f.gsub(/bin\//, "") }
  spec.test_files = Dir[File.join("test", "**", "*"), File.join("spec", "**", "*")]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "pry", "~> 0.9"
  spec.add_development_dependency "pry-doc", "~> 0.6"
end
