module RetinaImageHelper
  # Like the Rails image_tag, but adds a srcset attribute with an @2x version
  # of the image, thereby ensuring the image looks great on retina devices.
  # Assumes that the retina version of the image is named the same with "@2x"
  # before the extension, like "image@2x.png". For example:
  #
  #   <%= retina_image_tag("logo.png") %>
  #
  # Produces:
  #
  #   <img src="/assets/logo.png"
  #        srcset="/assets/logo.png 1x,/assets/logo@2x.png 2x">
  #
  # The srcset attribute is supported by modern desktop browsers and iOS 8+.
  def retina_image_tag(src, options={})
    src_1x = image_path(src)
    src_2x = image_path(src.sub(/^(.*)(\.[^\.]+)$/, '\1@2x\2'))
    srcset = "#{src_1x} 1x,#{src_2x} 2x"

    image_tag(src, options.reverse_merge(:srcset => srcset, :alt => ""))
  end
end
