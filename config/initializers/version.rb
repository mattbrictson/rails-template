Rails.application.config.version = begin
  `git describe --always --tag 2> /dev/null`.chomp
rescue
  "N/A"
end

Rails.application.config.version_date = begin
  Date.parse(`git log -1 --format="%ad" --date=short 2> /dev/null`)
rescue
  Time.now.to_date
end
