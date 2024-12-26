# app/controllers/posts_controller.rb
require "mini_magick"

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :download]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :approve, :disapprove, :set_score]
  after_action :verify_authorized, except: [:index, :download]

  # GET /posts or /posts.json
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
    #@posts = Post.most_hit(nil)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post.punch(request)
    @comments = @post.comments.includes(:user)
    authorize @post
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
    authorize @post
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Пост успешно создан." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /posts/1/edit
  def edit
    authorize @post
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    authorize @post

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Пост успешно обновлён." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    authorize @post

    @post.likes.destroy_all
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Пост успешно удалён." }
      format.json { head :no_content }
    end
  end

  def download
    @post = Post.friendly.find(params[:id])
    if @post.video.attached?
      send_data @post.video.download, filename: @post.video.filename.to_s
    else
      send_data @post.image.download, filename: @post.image.filename.to_s
    end
  end

  # PATCH /posts/:slug/approve
  def approve
    @post = Post.friendly.find(params[:slug])
    authorize @post

    score = params[:score].to_i  # Получаем оценку из формы

    @grade = @post.grade || @post.build_grade(student: @post.user)
    @grade.update!(status: true, score: score)  # Устанавливаем статус "зачтён" и сохраняем оценку

    redirect_to @post, notice: 'Пост зачтён и оценка установлена.'
  end


  def set_score
    @post = Post.friendly.find(params[:slug])
    authorize @post
    @grade = @post.grade || @post.build_grade(student: @post.user)
    score = params[:score].to_i

    if @grade.update(score: score)
      redirect_to grades_path, notice: "Оценка #{score} успешно установлена для студента #{@post.user.full_name}."
    else
      redirect_to @post, alert: "Ошибка при установке оценки."
    end
  end
  # PATCH /posts/:slug/disapprove
  def disapprove
    @post = Post.friendly.find(params[:slug])
    authorize @post

    @grade = @post.grade
    if @grade
      @grade.update!(status: false, score: nil)  # Сбрасываем статус и оценку
    end

    redirect_to @post, notice: 'Пост снят с зачёта.'
  end


  # PATCH /posts/:slug/set_score

  private

  def set_post
    @post = Post.friendly.find(params[:slug])
  end

  def post_params
    params.require(:post).permit(:title, :description, :image, :video)
  end
end
