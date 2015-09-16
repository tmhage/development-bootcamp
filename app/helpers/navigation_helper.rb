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
      options[:active] = request.path.match(url_for(object))
    end

    if options.delete(:active)
      options[:class] ||= ""
      options[:class] << " active"
      options[:class].strip!
    end

    content_tag(:li, link_to(content, object), options)
  end

  def menu_dropdown_for(name, options = {}, &block)
    content_tag(:li) do
      options[:class] = [options[:class], 'dropdown-toggle'].compact.uniq.join(' ')
      content_tag(:a, name.html_safe,
                  options.merge({href: '#', 'aria-expanded' => false, 'data-toggle' => 'dropdown', role: 'button'})) +
      content_tag(:ul, capture(&block))
    end
  end

  def navigation_cache_key
    "navigation-#{VERSION}-#{request.path}-#{Student.count}-#{Speaker.count}-#{Sponsor.count}"
  end
end
