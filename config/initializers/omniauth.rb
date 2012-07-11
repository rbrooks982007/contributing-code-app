OmniAuth.config.logger = Rails.logger


Rails.application.config.middleware.use OmniAuth::Builder do

  provider :developer unless Rails.env.production?
  if ENV['github_client_secret']
    provider :github, ENV['github_client_id'], ENV['github_client_secret'] # if SERVICES['github']
  else
    raise "Configure github_client_id and github_client_secret via environment variables"
  end

end
