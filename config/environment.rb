# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tumblrtv::Application.initialize!

ActionMailer::Base.smtp_settings = {	
  :user_name            => ENV['sendgrid_username'],
  :password             => ENV['sendgrid_password'],
  :domain               => "cloudfoundry.org",
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :authentication       => :plain,
  :enable_starttls_auto => false
}

