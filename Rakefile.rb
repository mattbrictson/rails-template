append_to_file "Rakefile" do
  <<~RUBY

  Rake::Task[:default].prerequisites.clear if Rake::Task.task_defined?(:default)
  task :default do
    sh "bin/rails test"
    sh "bin/rails test:system"

    raise unless
      system("bin/rubocop") &
      system("bin/erblint --lint-all") &
      system("yarn lint")
  end

  task :fix do
    raise unless
      system("bin/rubocop -a") &
      system("bin/erblint --lint-all -a") &
      system("yarn fix")
  end
  RUBY
end
