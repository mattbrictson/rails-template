module InlineSvgHelper
  def inline_svg_tag(filename, title: nil)
    svg = ViteInlineSvgFileLoader.named(filename)
    svg = svg.sub(/\A<svg/, '<svg role="img"')
    svg = svg.sub(/\A<svg.*?>/, safe_join(['\0', "\n", tag.title(title)])) if title.present?

    svg.strip.html_safe # rubocop:disable Rails/OutputSafety
  end
end
