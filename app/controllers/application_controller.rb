class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_host

  helper_method :current_user?
  helper_method :current_url

  # unless Rails.application.config.consider_all_requests_local
  if Rails.env.production?
    rescue_from ActionController::RoutingError, 
                ActiveRecord::RecordInvalid, 
                ActiveRecord::RecordNotFound, 
                ActionController::UnknownController, with: lambda {|exception| render_error 404, exception}
  end
  # end

  private

  def empty_flash
    flash.each do |k,v|
      flash.delete(k)
    end
  end

  # Returns a boolean value after checking if user is the current_user !
  def current_user?( user=nil )
    if !user
      user = User.find(params[:username])
    end
    return user == current_user ? true : false
  end

  # gives you the current url
  def current_url
    request.protocol + request.host_with_port + request.fullpath
  end

  def find_user_by_username
    if !(@user = User.find_by_slug( params[:username] ))
      raise ActiveRecord::RecordNotFound, "Page not found"
    end
  end

  # Redirect to another page to recommend user to follow places on two conditions
  #   1) not signed in more than 2 times
  #   2) does not follow more than 2 places
  # Subject to changes :)
  def after_sign_in_path_for( resource )
    user = current_user
    if ( user.sign_in_count < 3 )
      if user.sign_in_count == 1
        WelcomeMailer.delay.welcome( user )
      end
      all_following_places_path(user, ref: 'sign_up')
    else
      super
    end
  end

  def after_update_path_for( resource )
    user_path( current_user )
  end

  def render_error(status, exception)
    respond_to do |format|
      format.html { 
        # ErrorMailer.error_404( current_url , current_user ).deliver 
        render template: "errors/error_#{status}", layout: 'layouts/error', status: status 
      }
      format.json { 
        # ErrorMailer.error_404( current_url , current_user ).deliver 
        render nothing: true, status: status 
      }
    end
  end

  def check_host
    if request.host_with_port.split('.')[0] == 'www'
      redirect_to "http://" + request.host_with_port.gsub('www.','') + request.fullpath
    end
  end

  def check_ajax
    request.xhr?
  end
end
