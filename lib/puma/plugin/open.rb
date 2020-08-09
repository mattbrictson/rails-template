require "puma/plugin"

Puma::Plugin.create do
  def start(launcher)
    return unless defined?(Rails) && defined?(Launchy)
    return unless Rails.env.development?

    tcp = launcher.options[:binds].grep(/^tcp/).first
    return if tcp.nil?

    url = tcp.sub(/^tcp/, "http").sub("0.0.0.0", "localhost")
    Launchy.open(url)
  end
end
