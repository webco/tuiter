require 'rcov/rcovtask'

namespace :test do 
  namespace :coverage do
    desc "Open current coverage index page."
    task(:open) { system 'open "coverage/index.html"' if PLATFORM["darwin"] }
  end
  
  desc "Analyze code coverage of the unit tests."
  task :coverage => ['test:rcov', 'test:coverage:open']
  
  Rcov::RcovTask.new(:rcov) do |t|
    t.pattern = ENV["FROM"] || FileList['test/**/*_test.rb']
    t.output_dir = "coverage"
    t.rcov_opts = ["--text-summary", "-x gem,TextMate", "--charset UTF8", "--html"]
  end

  namespace :rcov do
    desc "Show current rcov version"
    task :version do
      system "rcov --version"
    end
  end

end

