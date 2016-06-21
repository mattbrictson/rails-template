require "test_helper"

class RetinaImageHelperTest < ActionView::TestCase
  include RetinaImageHelper

  test "retina_image_tag" do
    tag = retina_image_tag("example.png", :alt => "example")

    assert_match(%r{\A<img srcset=".*" alt=".*" src=".*" />\z}, tag)
    assert_match(/alt="example"/, tag)
    assert_match(%r{src="/images/example.png"}, tag)
    assert_match(
      %r{srcset="/images/example.png 1x,/images/example@2x.png 2x"},
      tag
    )
  end
end
