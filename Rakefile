#!/usr/bin/env ruby

require "rake"
require "rake/testtask"
require "rake/rdoctask"

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
  %w( Rakefile AUTHORS CHANGELOG LICENSE README.markdown ) + Dir["{lib,examples,test}/**/*"]
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
    s.files = spec_files

    # Dependencies
    s.add_dependency "json", ">= 1.1"
  end
end

desc "Creates the gemspec"
task "gemify" do
  skip_fields = %w(new_platform original_platform specification_version loaded required_ruby_version rubygems_version platform bindir )

  result = "# WARNING : RAKE AUTO-GENERATED FILE. DO NOT MANUALLY EDIT!\n"
  result << "# RUN : 'rake gem:update_gemspec'\n\n"
  result << "Gem::Specification.new do |s|\n"

  spec.instance_variables.each do |ivar|
    value = spec.instance_variable_get(ivar)
    name = ivar.split("@").last
    value = Time.now if name == "date"

    next if skip_fields.include?(name) || value.nil? || value == "" || (value.respond_to?(:empty?) && value.empty?)
    if name == "dependencies"
      value.each do |d|
        dep, *ver = d.to_s.split(" ")
        result << " s.add_dependency #{dep.inspect}, #{ver.join(" ").inspect.gsub(/[()]/, "").gsub(", runtime", "")}\n"
      end
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

task :default => ["test"]

