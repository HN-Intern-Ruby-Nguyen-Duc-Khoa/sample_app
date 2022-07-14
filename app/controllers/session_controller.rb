class SessionController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      # checkbox
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t ".danger_text"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def remember user
    user.remember_me
    # lưu vào cookies
    cookies[:remember_token] = { value: user.remember_token, expires: Settings.expires_token.years.from_now.utc }
    cookies.signed[:user_id] = { value: user.id, expires: Settings.expires_token.years.from_now.utc }
  end
end
