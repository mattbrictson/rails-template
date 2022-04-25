release_data = \
  if (tomo_json = Rails.root.join(".tomo_release.json")).file?
    JSON.parse(File.read(tomo_json))
  elsif (heroku_commit = ENV.fetch("HEROKU_SLUG_COMMIT", nil)).present?
    { "revision" => heroku_commit, "revision_date" => ENV.fetch("HEROKU_RELEASE_CREATED_AT", nil) }
  else
    { "revision" => "N/A", "revision_date" => Time.current.to_s }
  end

Rails.application.config.version = release_data["revision"]
Rails.application.config.version_time = Time.zone.parse(release_data["revision_date"])
