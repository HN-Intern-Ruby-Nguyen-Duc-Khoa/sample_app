class SessionController < ApplicationController
  def new; end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      log_in @user
      check_remember_me @user
      redirect_to @user
    else
      render_new
    end
  end

  private

  def check_remember_me user
    params[:session][:remember_me] ? remember(user) : forget(user)
  end

  def render_new
    flash.now[:danger] = t ".danger_text"
    render "new"
  end

  def remember user
    user.remember_me
    cookies[:remember_token] =
      {
        value: user.remember_token,
        expires: Settings.expires_token.years.from_now.utc
      }
    cookies.signed[:user_id] =
      {
        value: user.id,
        expires: Settings.expires_token.years.from_now.utc
      }
  end
end
