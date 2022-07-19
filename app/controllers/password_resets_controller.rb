class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
#      binding.pry
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent_info"
      redirect_to root_path
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def update
    # params[:first][:second] from form_for
    if params[:user][:password].empty?
      # binding.pry
      @user.errors.add :password, t(".password_not_empty")
      render 'edit'
    # hàm update của has_secure_password?
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t ".password_reset_success"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if (@user && @user.activated && @user.authenticated?(:reset, params[:id]))
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    # binding.pry
    return unless @user.password_reset_expired?
    flash[:danger] = t ".password_reset_expired"
    redirect_to new_password_reset_url
  end
end
