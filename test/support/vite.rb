# Compile assets at the start of testing if autoBuild is off
ViteRuby.commands.build unless ViteRuby.config.auto_build
