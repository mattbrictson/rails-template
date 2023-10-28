module LayoutHelper
  # Used to achieve nested layouts without content_for. This helper relies on
  # Rails internals, so beware that it may break with future major versions
  # of Rails. Inspired by http://stackoverflow.com/a/18214036
  #
  # Usage: For example, suppose "child" layout extends "parent" layout.
  # Use `= yield` as you would with non-nested layouts, as usual. Then on
  # the very last line of layouts/child.html.haml, include this:
  #
  #     - parent_layout "parent"
  #
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer) # rubocop:disable Rails/HelperInstanceVariable
    output = render(template: "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end
end
