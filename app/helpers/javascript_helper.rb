module JavascriptHelper
  # Adds the async attribute into javascript_include_tag, but only when the
  # asset pipeline is not in debug mode. Be careful when using this helper,
  # because async <script> tags have no load order guarantees.
  #
  # See also: http://www.html5rocks.com/en/tutorials/speed/script-loading/
  def javascript_include_async_tag(*args)
    options = args.extract_options!

    unless options["debug"] != false && request_debug_assets?
      options[:async] = true
    end

    javascript_include_tag(*args, options)
  end
end
