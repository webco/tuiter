# WARNING: RAKE AUTO-GENERATED FILE. DO NOT MANUALLY EDIT!
# RUN: 'rake gemify'

Gem::Specification.new do |s|
 s.date = "2009-03-20"
 s.authors = ["Manoel Lemos", "WebCo Internet"]
 s.require_paths = ["lib"]
 s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
 s.has_rdoc = false
 s.files = ["Rakefile",
 "AUTHORS",
 "CHANGELOG",
 "LICENSE",
 "README.rdoc",
 "lib/tuiter",
 "lib/tuiter/client.rb",
 "lib/tuiter/data",
 "lib/tuiter/data/rate_limit.rb",
 "lib/tuiter/data/status.rb",
 "lib/tuiter/data/user.rb",
 "lib/tuiter/version.rb",
 "lib/tuiter.rb",
 "examples/basic_example.rb"]
 s.email = "opensource@webcointernet.com"
 s.version = "0.0.1"
 s.homepage = "http://github.com/webco/tuiter"
 s.rubyforge_project = "tuiter"
 s.summary = "Yet another Twitter API wrapper library in Ruby"
 s.description = "Yet another Twitter API wrapper library in Ruby"
 s.name = "tuiter"
 
 if RUBY_PLATFORM  =~ /java/
   s.add_dependency "json_pure", ">= 1.1"
 else
   s.add_dependency "json", ">= 1.1"
 end
end
