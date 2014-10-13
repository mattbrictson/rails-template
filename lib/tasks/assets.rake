# Extend the default assets:precompile by additionally gzipping *all*
# assets. By default Rails only gzips .js and .css, and even then, only
# .js and .css that are compiled (e.g from scss). This extension ensures that
# big and easily-compressed files like SVGs also get gzipped.

namespace :assets do
  desc "Create .gz versions of static assets"
  task :gzip_static => :environment do
    zip_types = /\.(?:css|html|js|otf|svg|txt|xml)$/

    public_assets = File.join(
      Rails.root,
      "public",
      Rails.application.config.assets.prefix)

    Dir["#{public_assets}/**/*"].each do |f|
      next unless f =~ zip_types

      gz_file = "#{f}.gz"
      mtime = File.mtime(f)

      File.open(gz_file, "wb") do |dest|
        gz = Zlib::GzipWriter.new(dest, Zlib::BEST_COMPRESSION)
        gz.mtime = mtime.to_i
        gz.write(IO.read(f))
        gz.close
      end

      File.utime(mtime, mtime, gz_file)
    end
  end

  # Hook into existing assets:precompile task
  Rake::Task["assets:precompile"].enhance do
    Rake::Task["assets:gzip_static"].invoke
  end
end
