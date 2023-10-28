desc "Run HamlLint"
task :hamllint do
  sh "bin/haml-lint"
end

namespace :hamllint do
  desc "Autocorrect HamlLint offenses"
  task :autocorrect do
    sh "bin/haml-lint --auto-correct"
  end
end
