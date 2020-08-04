append_to_file "Rakefile" do
  <<~RUBY

  Rake::Task[:default].prerequisites.clear
  task :default do
    sh "bin/rails test"
    sh "HEADLESS_CHROME=1 bin/rails test:system"
    system "bin/rubocop"
    system "bin/yarn lint"
  end
  RUBY
end
