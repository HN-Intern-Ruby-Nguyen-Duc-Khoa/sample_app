class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
#    binding.pry
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".activated_success"
      redirect_to user
    else
      flash[:danger] = t ".activated_failed"
      redirect_to root_url
    end
  end
end