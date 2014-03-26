Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.logger = Logger.new(STDOUT)
  OmniAuth.logger.progname = "omniauth"
end
