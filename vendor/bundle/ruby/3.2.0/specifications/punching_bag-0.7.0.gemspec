# -*- encoding: utf-8 -*-
# stub: punching_bag 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "punching_bag".freeze
  s.version = "0.7.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Adam Crownoble".freeze]
  s.date = "2019-12-18"
  s.description = "PunchingBag is a hit counting and simple trending engine for Ruby on Rails".freeze
  s.email = "adam@codenoble.com".freeze
  s.homepage = "https://github.com/biola/punching_bag".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.5.3".freeze
  s.summary = "PunchingBag hit conter and trending plugin".freeze

  s.installed_by_version = "3.5.3".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<railties>.freeze, [">= 3.2".freeze])
  s.add_runtime_dependency(%q<voight_kampff>.freeze, [">= 1.0".freeze])
  s.add_development_dependency(%q<activerecord>.freeze, ["~> 5.2.3".freeze])
  s.add_development_dependency(%q<combustion>.freeze, ["~> 1.1".freeze])
  s.add_development_dependency(%q<rspec-its>.freeze, ["~> 1.3".freeze])
  s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.8".freeze])
  s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.4".freeze])
end
