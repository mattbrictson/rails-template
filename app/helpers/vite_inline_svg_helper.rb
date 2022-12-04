module ViteInlineSvgHelper
  def inline_svg(filename, title: nil)
    svg = read_vite_asset(filename)
    svg = svg.sub(/\A<svg.*?>/, safe_join(['\0', "\n", tag.title(title)])) if title.present?

    svg.html_safe # rubocop:disable Rails/OutputSafety
  end

  private

  def read_vite_asset(filename)
    vite = ViteRuby.instance
    vite_asset_path = vite.manifest.path_for(filename)

    if vite.dev_server_running?
      fetch_vite_dev_server_path(vite_asset_path)
    else
      Rails.cache.fetch("ViteInlineSvgHelper:#{filename}") do
        Rails.public_path.join(vite_asset_path.sub(%r{^/}, "")).read
      end
    end
  end

  def fetch_vite_dev_server_path(path)
    config = ViteRuby.config
    dev_server_uri = URI("#{config.protocol}://#{config.host_with_port}#{path}")
    response = Net::HTTP.get_response(dev_server_uri)
    raise "Failed to load inline SVG from #{dev_server_uri}" unless response.is_a?(Net::HTTPSuccess)

    response.body
  end
end
