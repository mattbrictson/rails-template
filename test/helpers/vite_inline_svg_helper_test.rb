require "test_helper"

class ViteInlineSvgHelperTest < ActionView::TestCase
  setup do
    @svg_path = Rails.root.join("app/frontend/images/vite_inline_svg_helper_test.svg")
    @svg_path.write <<~SVG
      <svg fill="none" viewBox="0 0 24 24" height="24" width="24" xmlns="http://www.w3.org/2000/svg">
      <path xmlns="http://www.w3.org/2000/svg" d="M12 4C12.5523 4 13 4.44772 13 5V11H19C19.5523 11 20 11.4477 20 12C20 12.5523 19.5523 13 19 13H13V19C13 19.5523 12.5523 20 12 20C11.4477 20 11 19.5523 11 19V13H5C4.44772 13 4 12.5523 4 12C4 11.4477 4.44772 11 5 11H11V5C11 4.44772 11.4477 4 12 4Z" fill="#0D0D0D"></path>
      </svg>
    SVG
  end

  teardown do
    @svg_path.unlink
  end

  test "inline_svg returns contents of svg file as html_safe string" do
    svg_result = inline_svg("images/vite_inline_svg_helper_test.svg")
    assert_predicate(svg_result, :html_safe?)
    assert_equal(<<~EXPECTED_SVG, svg_result)
      <svg fill="none" viewBox="0 0 24 24" height="24" width="24" xmlns="http://www.w3.org/2000/svg">
      <path xmlns="http://www.w3.org/2000/svg" d="M12 4C12.5523 4 13 4.44772 13 5V11H19C19.5523 11 20 11.4477 20 12C20 12.5523 19.5523 13 19 13H13V19C13 19.5523 12.5523 20 12 20C11.4477 20 11 19.5523 11 19V13H5C4.44772 13 4 12.5523 4 12C4 11.4477 4.44772 11 5 11H11V5C11 4.44772 11.4477 4 12 4Z" fill="#0D0D0D"></path>
      </svg>
    EXPECTED_SVG
  end

  test "inline_svg adds a <title> to the svg if specified" do
    svg_result = inline_svg("images/vite_inline_svg_helper_test.svg", title: "plus")
    assert_equal(<<~EXPECTED_SVG, svg_result)
      <svg fill="none" viewBox="0 0 24 24" height="24" width="24" xmlns="http://www.w3.org/2000/svg">
      <title>plus</title>
      <path xmlns="http://www.w3.org/2000/svg" d="M12 4C12.5523 4 13 4.44772 13 5V11H19C19.5523 11 20 11.4477 20 12C20 12.5523 19.5523 13 19 13H13V19C13 19.5523 12.5523 20 12 20C11.4477 20 11 19.5523 11 19V13H5C4.44772 13 4 12.5523 4 12C4 11.4477 4.44772 11 5 11H11V5C11 4.44772 11.4477 4 12 4Z" fill="#0D0D0D"></path>
      </svg>
    EXPECTED_SVG
  end
end
