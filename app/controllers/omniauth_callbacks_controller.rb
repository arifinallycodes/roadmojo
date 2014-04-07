class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Generate methods facebook and twitter
    ["facebook","twitter"].each do |provider|
      # self.class_eval "def #{provider}; sign_in_through_provider(\"#{provider}\"); end"
      self.class_eval "def #{provider}; connect_or_sign_up(\"#{provider}\"); end"
    end

  private

  def connect_or_sign_up(provider)
    if user_signed_in?
      connect_account( provider )
    else
      sign_in_through_provider( provider )
    end
  end

  # Generic method to sign user in through given provider.
  # Provider should be string representing calling method name,
  # e.g. "facebook", "twitter"
  def sign_in_through_provider( provider )
    @user = User.find_for_provider_oauth(request.env["omniauth.auth"], provider, current_user)
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, username: @user.username) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def connect_account( provider )
    session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
    # part below this works only for facebook provider. When you will be adding another provider
    # make sure to write an else case. If more providers then switch case. :-)
    fb_auth_token = session["devise.facebook_data"]["credentials"]["token"]
    respond_to do |format|

      # TODO:
      # Facebook does not allow a user to sign in to an app
      # The update is currently unsuccessful because of custom validation method on user model
      # named username_email
      # Move this validator in a better way so that we can atleast run the basic U of CRUD :-)
      
      user = current_user
      if user.update_attributes( fb_authentication_token: fb_auth_token )
        format.html { redirect_to dashboard_path, notice: "success !" }
        format.json { head :ok }
      else
        format.html { redirect_to dashboard_path, alert: user.errors }
        format.json { render json: user.errors, status: :unprocessably_entity }
      end
    end
  end
end