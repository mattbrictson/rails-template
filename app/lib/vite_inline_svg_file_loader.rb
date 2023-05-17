module ViteInlineSvgFileLoader
  class << self
    def named(filename)
      vite = ViteRuby.instance
      vite_asset_path = vite.manifest.path_for(filename)

      if vite.dev_server_running?
        fetch_from_dev_server(vite_asset_path)
      else
        Rails.public_path.join(vite_asset_path.sub(%r{^/}, "")).read
      end
    end

    private

    def fetch_from_dev_server(path)
      config = ViteRuby.config
      dev_server_uri = URI("#{config.protocol}://#{config.host_with_port}#{path}")
      response = Net::HTTP.get_response(dev_server_uri)
      raise "Failed to load inline SVG from #{dev_server_uri}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    end
  end
end
