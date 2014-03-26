class InviteMailer < ActionMailer::Base

  def invite_people( inviter=nil, invitee )
  	@inviter = inviter
  	@invitee = invitee
  	subject = @inviter ? "#{inviter.username} has invited you to join Roadmojo" : "You have been invited to Roadmojo"
    mail(to: invitee.email,from: "admin@roadmojo.com", subject: subject)
  end
end