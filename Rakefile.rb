append_to_file "Rakefile" do
  <<~RUBY

  Rake::Task[:default].prerequisites.clear if Rake::Task.task_defined?(:default)
  task :default do
    sh "bin/rails test"
    sh "bin/rails test:system"

    raise unless
      system("bin/rubocop") &
      system("yarn lint")
  end
  RUBY
end
