# frozen_string_literal: true

require_relative "lib/internal_notifications/version"

Gem::Specification.new do |spec|
  spec.name = "internal-notifications"
  spec.version = InternalNotifications::VERSION
  spec.authors = ["devs@buda.com"]
  spec.summary = "Internal Notifications Messenger"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", [">= 5.0", "< 8.0"]
  spec.add_dependency "google-cloud-pubsub"
  spec.add_dependency "power-types"
  spec.add_development_dependency "bundler", "~> 2.3.7"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-rails", "~> 6.0"
end
