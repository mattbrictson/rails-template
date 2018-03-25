# Mocha provides mocking and stubbing helpers
require "mocha/minitest"
Mocha::Configuration.prevent(:stubbing_non_existent_method)
Mocha::Configuration.warn_when(:stubbing_non_public_method)
