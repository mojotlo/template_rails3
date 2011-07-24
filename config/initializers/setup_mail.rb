ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  #:port                 => 25,  
  #:domain               => "empanadaintifada.com",  
  :user_name            => "empanada.intifada ",  
  :password             => "Empanarme",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
}