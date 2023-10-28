inject_into_file(
  "config/application.rb",
  "puma/plugin ",
  after: /autoload_lib\(ignore: %w./
)
copy_file "lib/puma/plugin/open.rb"
copy_file "lib/tasks/auto_annotate_models.rake"
copy_file "lib/tasks/haml_lint.rake"
copy_file "lib/tasks/rubocop.rake"
copy_file "lib/tasks/yarn.rake"
