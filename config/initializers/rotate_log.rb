# Rotates development and test log files when they exceed 20 MB.
# In production use a more robust system like /etc/logrotate.d/.
#
if Rails.env.development? || Rails.env.test?
  log_file = Rails.root.join("log", "#{Rails.env}.log")

  if log_file.file? && log_file.size > 20_000_000
    FileUtils.cp(log_file, "#{log_file}.1")
    log_file.truncate(0)
  end
end
