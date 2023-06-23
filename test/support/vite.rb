return if ViteRuby.config.auto_build

# Compile assets once at the start of testing
millis = Benchmark.ms { ViteRuby.commands.build }
puts format("Built Vite assets (%.1fms)", millis)
