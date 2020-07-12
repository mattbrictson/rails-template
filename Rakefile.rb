append_to_file "Rakefile" do
  <<~RUBY

  task default: %w[test test:system]
  RUBY
end
