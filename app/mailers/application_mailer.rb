class ApplicationMailer < ActionMailer::Base
  default from: ENV["mail_address"]
  layout "mailer"
end
