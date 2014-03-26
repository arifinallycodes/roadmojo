class LikeMailer < ActionMailer::Base
  
  def like_trip(owner, user, trip)
    @user = user
    @trip = trip
    @owner = owner
    subject = "#{@user.username} just liked your trip"
    if Rails.env.production?
      @url = "http://roadmojo.com"
    else
      @url = "http://localhost:3000"
    end
    mail(to: owner.email,from: "admin@roadmojo.com", subject: subject)
  end
end
