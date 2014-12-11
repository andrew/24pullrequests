class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :current_year, :admin?

  before_action :set_locale, :ensure_email_address_confirmed

  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  def ensure_email_address_confirmed
    if logged_in? && current_user.confirmed_at.nil?
      flash.now[:notice] = "You must confirm your email address"
    end
  end

  private

  def ensure_logged_in
    unless logged_in?
      flash[:notice] = 'You must be logged in to view this content.'

      session[:pre_login_destination] = "http://#{request.host_with_port}#{request.path}"
      redirect_to login_path
    end
  end

  def current_year
    @year ||= (params[:year].try(:to_i) || CURRENT_YEAR)
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def admin?
    current_user.admin?
  end
end
