class RegistrationsController < Devise::RegistrationsController
  def new
    @facebook_signup = facebook_signup?
    @twitter_signup = twitter_signup?
    @google_signup = google_signup?
    puts session["devise.facebook_data"].as_json
    puts 'you are in RegistrationsController new %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' 
    if @facebook_signup || @twitter_signup || @google_signup
      puts'##################################################################################################################################'
      puts 'you are in facebook_signup present new %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' 
      flash.now[:notice] = "Almost done! We'll just need you to enter your Roadmojo username and you'll be ready to ride."
    end
    super
  end

  def create
    puts 'you are in RegistrationsController create %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' 
    @facebook_signup = facebook_signup?
    # super
    if google_signup?
      resource = User.build_resource(session["devise.google_oauth2_data"].as_json,"google_oauth2")
    elsif facebook_signup?
      resource = User.build_resource(session["devise.facebook_data"].as_json,"facebook") 
    elsif twitter_signup?
      resource = User.build_resource(session["devise.twitter_data"].as_json,"twitter") 
      resource.email = params["user"]["email"] if params["user"]
    else
      resource = User.new(email: params["user"]["email"]) if params["user"]
    end
    resource.username = params["user"]["username"]
    if needs_password?(resource,params)
      resource.password = assign_password
    else
      resource.password = params["user"]["password"]
    end
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        # respond_with resource, :location => after_sign_up_path_for(resource)
        redirect_to new_user_session_path
      else
        set_flash_message :notice, "signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        redirect_to new_user_session_path
        # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
      # if special_emails.include?( resource.email )
      if SpecialEmail.find_by_email( resource.email )
        resource.update_column('confirmation_token',nil)
        resource.update_column('confirmed_at',Time.now)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # manually overriding the update action so that user can update without having to pass in the 
  # password each time he/she updates something.
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      # redirect_to after_update_path_for(@user)
      redirect_to user_path( @user )
    else
      # flash[:alert] = @user.errors
      render "edit"
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] || params[:user][:password].blank?
  end

  def assign_password
    SecureRandom.hex(20)
  end

  protected

  def facebook_signup?
    session["devise.facebook_data"].present?
  end

  def twitter_signup?
    session["devise.twitter_data"].present?
  end

  def google_signup?
    session["devise.google_oauth2_data"].present?
  end

end
