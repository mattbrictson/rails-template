gsub_file "config/application.rb",
          "# config.time_zone = 'Central Time (US & Canada)'",
          'config.time_zone = "Pacific Time (US & Canada)"'

insert_into_file "config/boot.rb",
                 %Q(require "bootsnap/setup" unless ENV["DISABLE_BOOTSNAP"]\n),
                 :after => %r{bundler/setup.*$\n}
