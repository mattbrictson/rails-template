require "test_helper"

class JavascriptHelperTest < ActionView::TestCase
  include Sprockets::Rails::Helper
  include JavascriptHelper

  setup do
    allow_unknown_assets
  end

  test "#javascript_include_async_tag doesn't do anything in debug mode" do
    Mocha::Configuration.allow(:stubbing_non_public_method) do
      stubs(:request_debug_assets?).returns(true)
    end
    js_tag = javascript_include_tag("foo", :skip_pipeline => true)
    js_async_tag = javascript_include_async_tag("foo", :skip_pipeline => true)
    assert_equal(js_tag, js_async_tag)
  end

  test "javascript_include_async_tag adds async attribute" do
    assert_equal(
      '<script src="/javascripts/foo.js" async="async"></script>',
      javascript_include_async_tag("foo", :skip_pipeline => true)
    )
  end

  # This allows non-existent asset filenames to be used within a test, for
  # sprockets-rails >= 3.2.0.
  def allow_unknown_assets
    return unless respond_to?(:unknown_asset_fallback)
    stubs(:unknown_asset_fallback).returns(true)
  end
end
