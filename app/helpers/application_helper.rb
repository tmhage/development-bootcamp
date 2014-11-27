module ApplicationHelper
  def title(title, suffix=true)
    title += " - Development Bootcamp" if suffix
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
end
