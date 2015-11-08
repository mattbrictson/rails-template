# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Include tasks from other gems included in your Gemfile
require "airbrussh/capistrano"
require "capistrano/bundler"
require "capistrano/rails"
require "capistrano/mb"
require "capistrano-nc/nc"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
