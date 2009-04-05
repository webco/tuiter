#!/usr/bin/env ruby

require "rake"
require "rake/testtask"
require "rake/rdoctask"
require 'rcov/rcovtask'

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].each do |req|
  load req
end

require "lib/tuiter/version"

desc "Run test suite"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

desc "Report code statistics (KLOCs, etc) from the library"
task "stats" do
  require "code_statistics"
  ::CodeStatistics::TEST_TYPES << "Tests"
  ::CodeStatistics.new(["Libraries", "lib"], ["Tests", "test"]).to_s
end

desc "List the names of the test methods"
task "list" do
  $LOAD_PATH.unshift("test")
  $LOAD_PATH.unshift("lib")
  require "test/unit"
  Test::Unit.run = true
  test_files = Dir.glob(File.join('test', '**/*_test.rb'))
  test_files.each do |file|
    load file
    klass = File.basename(file, '.rb').classify.constantize
    puts klass.name.gsub('Test', '')
    test_methods = klass.instance_methods.grep(/^test/).map {|s| s.gsub(/^test: /, '')}.sort
    test_methods.each {|m| puts "  " + m }
  end
end

def spec_files
  %w( Rakefile AUTHORS CHANGELOG LICENSE README.rdoc ) + Dir["{lib,examples,test}/**/*"]
end

def spec
  spec = Gem::Specification.new do |s|
    s.name = "tuiter"
    s.version = Tuiter::VERSION::STRING 
    s.summary = "Yet another Twitter API wrapper library in Ruby"
    s.authors = ["Manoel Lemos", "WebCo Internet"]
    s.email = "opensource@webcointernet.com"
    s.homepage = "http://github.com/webco/tuiter"
    s.description = "Yet another Twitter API wrapper library in Ruby"
    s.has_rdoc = false
    # s.extra_rdoc_files = ["LICENSE", "README.rdoc", "CHANGELOG"]
    # s.rdoc_options = ["--inline-source", "--charset=utf-8"]
    s.files = spec_files
    s.rubyforge_project = "tuiter"

    # Dependencies
    s.add_dependency "json", ">= 1.1"
  end
end

desc "Creates the gemspec"
task "gemify" do
  skip_fields = %w(new_platform original_platform specification_version loaded required_ruby_version rubygems_version platform bindir )

  result = "# WARNING: RAKE AUTO-GENERATED FILE. DO NOT MANUALLY EDIT!\n"
  result << "# RUN: 'rake gemify'\n\n"
  result << "Gem::Specification.new do |s|\n"

  spec.instance_variables.each do |ivar|
    value = spec.instance_variable_get(ivar)
    name = ivar.split("@").last
    value = Date.today.to_s if name == "date"

    next if skip_fields.include?(name) || value.nil? || value == "" || (value.respond_to?(:empty?) && value.empty?)
    if name == "dependencies"
      value.each do |d|
        dep, *ver = d.to_s.split(" ")
        result << " s.add_dependency #{dep.inspect}, #{ver.join(" ").inspect.gsub(/[()]/, "").gsub(", runtime", "")}\n"
      end
    elsif name == "required_rubygems_version"
      result << " s.required_rubygems_version = Gem::Requirement.new(\">= 0\") if s.respond_to? :required_rubygems_version=\n"
    else
      case value
      when Array
        value = name != "files" ? value.inspect : value.inspect.split(",").join(",\n")
      when FalseClass
      when TrueClass
      when Fixnum
      when String
        value = value.inspect
      else
        value = value.to_s.inspect
      end
      result << " s.#{name} = #{value}\n"
    end
  end
  
  result << "end"
  File.open(File.join(File.dirname(__FILE__), "#{spec.name}.gemspec"), "w"){|f| f << result}
end

desc "Build the gem"
task "build" => "gemify" do
  sh "gem build #{spec.name}.gemspec"
end

desc "Install the gem locally"
task "install" => "build" do
  sh "gem install #{spec.name}-#{spec.version}.gem && rm -r *.gem *.gemspec"
end

desc "Publish the gem to Rubyforge"
task "publish" => "build" do
  require 'rubyforge'
  rubyforge_config_path = File.expand_path(File.join('~', '.rubyforge'))
  user_config = YAML::load(File.open(rubyforge_config_path + '/user-config.yml'))
  auto_config = YAML::load(File.open(rubyforge_config_path + '/auto-config.yml'))

  @rubyforge = RubyForge::Client.new(user_config, auto_config)

  @rubyforge.login
  @rubyforge.add_release('tuiter', 'tuiter', "#{spec.version}", "#{spec.name}-#{spec.version}.gem")
end

desc "Rcov"
Rcov::RcovTask.new(:rcov)  do |t|
  t.pattern = ENV["FROM"] || FileList["test/**/*_test.rb"]
  t.output_dir = "coverage"
  t.rcov_opts = ["-x gem,TextMate", "--text-summary", "--html", "--charset UTF8"]
  # t.rcov_opts = ["-x gem,TextMate", "--text-summary", "--html", "--charset UTF8"]
end

task :default => ["test"]

