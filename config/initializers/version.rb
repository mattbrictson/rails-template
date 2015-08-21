Rails.application.config.version = begin
  `git describe --always --tag 2> /dev/null`.chomp
rescue
  "N/A"
end

Rails.application.config.version_time = begin
  time = Time.zone.parse(`git log -1 --format="%ad" --date=iso 2> /dev/null`)
  time || Time.zone.now
rescue
  Time.zone.now
end
