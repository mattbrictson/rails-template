require "puma/plugin"

Puma::Plugin.create do
  def start(launcher)
    return unless defined?(Rails) && defined?(Launchy)
    return unless Rails.env.development?

    binding = launcher.options[:binds].grep(/^tcp|ssl/).first
    return if binding.nil?

    url = binding.sub(/^tcp/, "http").sub(/^ssl/, "https").sub("0.0.0.0", "localhost")
    Launchy.open(url)
  end
end
