class StaticPageController < ApplicationController
  def home; end

  def help; end

  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy(current_user.feed)
  end
end
