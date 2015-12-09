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

  def tweet_button
    link_to "Tweet", "https://twitter.com/share",
      class: "twitter-share-button",
      data: {
        via: "devbootcamps",
        related: "codaisseur",
        hashtags: "nltech"
      }
  end
end
