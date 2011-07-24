ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  #:port                 => 25,   
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}