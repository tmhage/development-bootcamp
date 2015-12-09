module SocialHelper
  def like_button
    content_tag(:div, "",
      class: 'fb-like',
      data: {
        href: request.original_url,
        layout: :standard,
        action: :like,
        show_faces: false
      }
    )
  end
end
