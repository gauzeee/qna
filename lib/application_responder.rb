class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # Redirects resources to the collection path (index action) instead
  # of the resource path (show action) for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder
  if env.respond_to?(:register_transformer)
    env.register_mime_type 'text/css', extensions: ['.css'], charset: :css
    env.register_preprocessor 'text/css', MySprocketsExtension
  end

  if env.respond_to?(:register_engine)
    args = ['.css', MySprocketsExtension]
    args << { mime_type: 'text/css', silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
    env.register_engine(*args)
  end
end
