desc "Run erblint"
task :erblint do
  sh "bin/erblint --lint-all"
end

namespace :erblint do
  desc "Autocorrect erblint offenses"
  task :autocorrect do
    sh "bin/erblint --lint-all -a"
  end
end
