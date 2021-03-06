# WARNING: RAKE AUTO-GENERATED FILE. DO NOT MANUALLY EDIT!
# RUN: 'rake gemify'

Gem::Specification.new do |s|
 s.date = "2009-05-09"
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
 "lib/tuiter/data/direct_message.rb",
 "lib/tuiter/data/rate_limit.rb",
 "lib/tuiter/data/status.rb",
 "lib/tuiter/data/user.rb",
 "lib/tuiter/methods",
 "lib/tuiter/methods/account.rb",
 "lib/tuiter/methods/direct_message.rb",
 "lib/tuiter/methods/friendship.rb",
 "lib/tuiter/methods/social_graph.rb",
 "lib/tuiter/methods/status.rb",
 "lib/tuiter/methods/user.rb",
 "lib/tuiter/utils.rb",
 "lib/tuiter/version.rb",
 "lib/tuiter.rb",
 "examples/basic_example.rb",
 "test/fixtures",
 "test/fixtures/followers.json",
 "test/fixtures/replies.json",
 "test/fixtures/tuitersfera.json",
 "test/fixtures/user_basic.json",
 "test/fixtures/user_timeline.json",
 "test/macros",
 "test/macros/attr_accessor_macro.rb",
 "test/test_helper.rb",
 "test/unit",
 "test/unit/client_test.rb",
 "test/unit/rate_limit_test.rb",
 "test/unit/status_test.rb",
 "test/unit/user_test.rb",
 "test/unit/utils_test.rb"]
 s.email = "opensource@webcointernet.com"
 s.version = "0.0.7"
 s.homepage = "http://github.com/webco/tuiter"
 s.rubyforge_project = "tuiter"
 s.name = "tuiter"
 s.summary = "Yet another Twitter API wrapper library in Ruby"
 s.description = "Yet another Twitter API wrapper library in Ruby"
 s.add_dependency "json", ">= 1.1"
 s.add_dependency 'oauth', '>= 0.3.4'
end
