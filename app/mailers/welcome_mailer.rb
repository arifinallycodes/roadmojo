class WelcomeMailer < ActionMailer::Base
  
  def welcome(user)
    @user = user
    subject = "Welcome to Roadmojo"
    if Rails.env.production?
  	  @url = "http://roadmojo.com/assets/welcome_mailer/"
  	else
  	  @url = "http://localhost:3000/assets/welcome_mailer/"
  	end
    mail(to: @user.email, from: "admin@roadmojo.com", subject: subject)
  end
end