require "test_helper"

class LayoutHelperTest < ActionDispatch::IntegrationTest
  test "rendered page contains both base and application layouts" do
    visit("/")
    assert(page.has_selector?("html>head+body"))
    assert(page.has_selector?("body p"))
    assert_match(/Home/, page.title)
  end
end
