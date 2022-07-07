class UsersController < ApplicationController
  USER_PARAMS = %i(name email password password_confirmation).freeze

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".show_user_failed"
    redirect_to root_url
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash.now[:danger] = t ".failed"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit USER_PARAMS
  end
end
