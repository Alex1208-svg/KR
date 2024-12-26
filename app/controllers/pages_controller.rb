class PagesController < ApplicationController
  def media
    if user_signed_in?
      @posts = current_user.posts
  
      if @posts.empty?
      @message = "У вас ещё нет загруженных постов."
      else
        @message = "Ваше портфолио:"
      end

      end
  end


  def tos


  end
end
