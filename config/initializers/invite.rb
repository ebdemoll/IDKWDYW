if Rails.env.development?
  ActionMailer::Base.delivery_method = :sendmail
  ActionMailer::Base.smtp_settings = { address: 'localhost', port: 1025 }
else
  ActionMailer::Base.smtp_settings = {
    :user_name => ENV['gmail_username'],
    :password => ENV['gmail_password'],
    :domain => 'https://idkwdyw-nothing-fight.herokuapp.com/',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end