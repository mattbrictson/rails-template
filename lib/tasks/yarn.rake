namespace :yarn do
  desc "Run yarn lint script"
  task :lint do
    sh "yarn lint"
  end

  desc "Run yarn fix script"
  task :fix do
    sh "yarn fix"
  end
end
