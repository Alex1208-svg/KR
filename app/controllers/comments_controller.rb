class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'Комментарий добавлен.'
    else
      redirect_to post_path(@post), alert: 'Ошибка при добавлении комментария.'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Комментарий обновлён.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: 'Комментарий успешно удален.'
  end

  private

  def set_post
    @post = Post.friendly.find_by(slug: params[:post_slug])
  end

  def set_comment
    @comment = @post.comments.find_by(id: params[:id])
    redirect_to @post, alert: "Комментарий не найден" if @comment.nil?
  end

  def authorize_user!
    redirect_to @post, alert: "Вы не можете изменить этот комментарий" unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
