append_to_file "Rakefile" do
  <<~RUBY

  Rake::Task[:default].prerequisites.clear if Rake::Task.task_defined?(:default)

  desc "Run all checks"
  task default: %w[test:all rubocop haml_lint yarn:lint] do
    Thor::Base.shell.new.say_status :OK, "All checks passed!"
  end

  desc "Apply auto-corrections"
  task fix: %w[rubocop:autocorrect_all haml_lint:autocorrect yarn:fix] do
    Thor::Base.shell.new.say_status :OK, "All fixes applied!"
  end
  RUBY
end
