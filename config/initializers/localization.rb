I18n.default_locale = :en
I18n.available_locales= [:en, :nl]

RouteTranslator.config do |config|
  config.force_locale = false
  config.locale_param_key = :locale
end
