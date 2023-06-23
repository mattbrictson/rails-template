return if ViteRuby.config.auto_build

# Compile assets once at the start of testing
Benchmark.ms { ViteRuby.instance.builder.build }.tap do |millis|
  puts format("Built Vite assets (%.1fms)", millis)
end
