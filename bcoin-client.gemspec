# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bcoin/client/version"

Gem::Specification.new do |spec|
  spec.name          = "bcoin-client"
  spec.version       = Bcoin::Client::VERSION
  spec.authors       = ["Dan Knox"]
  spec.email         = ["dknox@threedotloft.com"]

  spec.summary       = %q{Client for the bcoin.io bitcoin node.}
  spec.description   = %q{Client for the bcoin.io bitcoin node including their wallet API.}
  spec.homepage      = "http://github.com/DanKnox-BitFS/bcoin-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_dependency "httparty", "~> 0.15"
end
