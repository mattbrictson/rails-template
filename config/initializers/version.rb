TomoReleaseData = begin
  json_path = Rails.root.join(".tomo_release.json")
  data = json_path.file? ? JSON.parse(IO.read(json_path)) : {}
  data.freeze
end

Rails.application.config.version = TomoReleaseData.fetch("revision", "N/A")
Rails.application.config.version_time = begin
  timestamp = TomoReleaseData.fetch("revision_date", Time.current.to_s)
  Time.zone.parse(timestamp)
end
