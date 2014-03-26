class ErrorMailer < ActionMailer::Base

  def error_404( url, current_user )
  	@url = url
  	to = 'team@roadmojo.com'
  	subject = "404 error : #{url}"
  	@current_user = current_user ? current_user.username : 'Random User'
    mail( 
    	  to: to, 
    	  from: "admin@roadmojo.com",
    	  subject: subject 
    	)
  end
end
