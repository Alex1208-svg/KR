class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin_or_teacher
  before_action :set_user, only: [:edit, :update, :destroy]
  def new
    @user = User.new
  end

  def index
    @users = User.page(params[:page]).per(10)
    render :index
    respond_to do |format|
      format.html # Обычный HTML-шаблон
      format.json { render json: @users } # API-ответ
    end
  end
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'Пользователь успешно создан.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'Данные пользователя успешно обновлены.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'Пользователь удалён.'
  end

  private

  def ensure_admin_or_teacher
    redirect_to root_path, alert: 'Доступ запрещён.' unless current_user.admin_or_teacher?
  end

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path, alert: 'Пользователь не найден.' unless @user
  end

  def user_params
    permitted_roles = User.roles.keys - ['admin'] # Исключить admin
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation, :role).tap do |whitelisted|
      whitelisted[:role] = 'student' unless permitted_roles.include?(params[:user][:role])
    end
  end
end
