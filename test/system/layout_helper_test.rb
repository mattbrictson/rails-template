require "application_system_test_case"

class LayoutHelperTest < ApplicationSystemTestCase
  test "rendered page contains both base and application layouts" do
    visit("/")
    assert_selector("html>head+body")
    assert_selector("body p")
    assert_match(/Home/, page.title)
  end
end
