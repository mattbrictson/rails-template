require "test_helper"

class InlineSvgHelperTest < ActionView::TestCase
  test "inline_svg_tag returns contents of svg file as html_safe string" do
    svg_result = inline_svg_tag("images/example.svg")
    assert_predicate(svg_result, :html_safe?)
    assert_equal(<<~EXPECTED_SVG.strip, svg_result)
      <svg role="img" width="180" height="180" viewBox="0 0 180 180" fill="none" xmlns="http://www.w3.org/2000/svg">
      <rect x="2" y="2" width="176" height="176" rx="6" fill="white" stroke="#CCCCCC" stroke-width="4" stroke-miterlimit="0" stroke-linecap="round"/>
      </svg>
    EXPECTED_SVG
  end

  test "inline_svg_tag adds a <title> to the svg if specified" do
    svg_result = inline_svg_tag("images/example.svg", title: "rounded box")
    assert_equal(<<~EXPECTED_SVG.strip, svg_result)
      <svg role="img" width="180" height="180" viewBox="0 0 180 180" fill="none" xmlns="http://www.w3.org/2000/svg">
      <title>rounded box</title>
      <rect x="2" y="2" width="176" height="176" rx="6" fill="white" stroke="#CCCCCC" stroke-width="4" stroke-miterlimit="0" stroke-linecap="round"/>
      </svg>
    EXPECTED_SVG
  end
end
