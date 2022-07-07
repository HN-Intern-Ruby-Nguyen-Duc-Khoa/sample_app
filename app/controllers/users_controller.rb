class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new index)
  before_action :load_user, except: %i(create new index)
  before_action :correct_user, only: %i(edit update)

  def index
    @pagy, @users = pagy(User.all.order_by_name, items: Settings.users.per_page)
  end

  def new
    @user = User.new
  end

  def show
    return if @user

    flash[:danger] = t ".show_user_failed"
    redirect_to root_path
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

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_successfully"
      redirect_to @user
    else
      flash.now[:danger] = t ".update_failed"
      render :edit
    end
  end

  def destroy
    if user.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
    redirect_to users_path
  end

  private

  def correct_user
    return if current_user? @user

    flash[:danger] = t ".edit_correct_danger"
    redirect_to root_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:info] = I18n.t "users.load_user.error"
  end

  def user_params
    params.require(:user).permit USER_PARAMS
  end
end
