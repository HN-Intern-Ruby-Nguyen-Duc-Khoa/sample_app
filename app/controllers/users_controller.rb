class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  USER_PARAMS = %i(name email password password_confirmation).freeze

  def index
    #binding.pry
    @users = User.paginate(page: params[:page], per_page: Settings.users.per_page)
  end

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

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update user_params
      flash[:"success"] = t ".update_successfully"
      redirect_to @user
    else
      flash.now[:"danger"] = t ".update_failed"
      render "edit"
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".edit_login_danger"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id:params[:id]
    return if current_user? @user

    flash[:"danger"] = t ".edit_correct_danger"
    redirect_to root_url
  end

  def destroy
    user = User.find_by id: params[:id]
    if user&.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit USER_PARAMS
  end
end
