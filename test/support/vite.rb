return if ViteRuby.config.auto_build

# Compile assets once at the start of testing
millis = Benchmark.ms { ViteRuby.instance.builder.build }
puts format("Built Vite assets (%.1fms)", millis)
