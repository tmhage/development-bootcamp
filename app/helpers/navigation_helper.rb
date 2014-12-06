module NavigationHelper
  VERSION = "v1"

  def menu_item_for(*args, &block)
    if block_given?
      object = args[0]
      content = capture(&block)
      options = (args[1] || {}).with_indifferent_access
    else
      object = args[1]
      content = args[0]
      options = (args[2] || {}).with_indifferent_access
    end

    if options[:active].nil?
      options[:active] = url_for(object) == request.path
    end

    if options.delete(:active)
      options[:class] ||= ""
      options[:class] << " active"
      options[:class].strip!
    end

    content_tag(:li, link_to(content, object), options)
  end

  def navigation_cache_key
    "navigation-#{VERSION}"
  end
end
