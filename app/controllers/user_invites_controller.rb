class UserInvitesController < ApplicationController
  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }

  respond_to :html, :js, :json
  def create
    @invite = current_user ? current_user.user_invites.new : UserInvite.new
    @invite.email = params[:invite_email]
    @invite.sign_up_token = SecureRandom.hex(16)
    if @invite.save
      InviteMailer.invite_people( current_user, @invite ).deliver
      respond_with( @invite )
    else
      respond_with( @invite )
    end
  end
end