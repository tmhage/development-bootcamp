module ApplicationHelper
  def title(title, suffix=true)
    title += " – Development Bootcamp, Amsterdam" if suffix
    content_for :title, title
  end

  # Public: Sets the meta description for the current page
  #
  # description - The String containing the description
  def meta_description(description)
    content_for :meta_description, description
  end

  # Public: Sets the meta keywords for the current page
  #
  # keywords - The String containing the keywords
  def meta_keywords(keywords)
    content_for :meta_keywords, keywords
  end

  # Public: Defines crawling instructions for the current page
  #
  # directive - The String containing the instructions for the crawler
  def meta_robots(directive)
    content_for :meta_robots, directive
  end

  # Public: Defines a sharing image for the current page. Social media
  # sites use these images in their previews.
  #
  # image - the (uploaded) image to link to.
  def meta_image(image)
    content_for :meta_image, image_url(image)
  end

  # Public: Whether or not to show the sidebar based on a configurable
  # variable: @show_sidebar.
  #
  # Returns: boolean, default: true.
  def show_sidebar?
    return true if @show_sidebar.nil?
    @show_sidebar
  end

  def localized_cache(*args, &block)
    cache [I18n.locale, File.ctime(Rails.root.join("config", "locales", "#{I18n.locale}.yml"))] + args do
      yield block
    end
  end
end
