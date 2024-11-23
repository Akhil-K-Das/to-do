require 'mailgun-ruby'

MailgunClient = Mailgun::Client.new(Rails.application.credentials.dig(:mailgun, :api_key))
MAILGUN_DOMAIN = Rails.application.credentials.dig(:mailgun, :domain)
