class OpenDayDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def date
    object.starts_at.to_formatted_s(:short)
  end

  def description
    return object.description_nl.html_safe if I18n.locale == :nl
    object.description_en.html_safe
  end

  def google_maps_url
    "https://www.google.com/maps/place/#{object.address.gsub(/ /, '+')}/@#{object.latitude},#{object.longitude}"
  end

  def google_maps_embed_url
    "https://www.google.com/maps/embed/v1/place?key=AIzaSyD5BFlLJ_VpC5b4JfHPy1pMHZILHGbzhSM&q=#{object.address.gsub(/ /, '+')}"
  end

  def google_maps_iframe
    h.content_tag :iframe, '',
      src: google_maps_embed_url,
      width: "100%",
      height: "450",
      frameborder: "0",
      style: "border:0",
      allowfullscreen: true
  end

end
