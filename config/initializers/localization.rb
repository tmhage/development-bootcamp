I18n.available_locales= [:en, :nl]

RouteTranslator.config do |config|
  config.host_locales =
    {
      '*.nl'                 => :nl,
      '*.com'                => :en,
      '*.nl.dev'             => :nl,
      '*.com.dev'            => :en,
    }
end
