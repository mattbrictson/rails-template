append_to_file "Rakefile" do
  <<~RUBY

  task :overcommit do
    sh "bundle exec overcommit --run"
  end

  task default: %w[test test:system overcommit]
  RUBY
end
