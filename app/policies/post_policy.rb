# app/policies/post_policy.rb
class PostPolicy < ApplicationPolicy

  def create?
    user.teacher? || user.student? || user.admin? # Разрешить всем пользователям создавать посты
  end

  def show?
    user.teacher? || record.user == user || user.admin?  # Разрешить просмотр только учителям или владельцам поста
  end

  def approve?
    user.teacher? || user.admin?
  end

  def disapprove?
    user.teacher? || user.admin?
  end

  def set_score?
    # Только преподаватели могут устанавливать оценки
    user.teacher? || user.admin?
  end

  def edit?
    user.teacher? || record.user == user || user.admin?  # Разрешить редактировать только учителям или владельцам поста
  end

  def update?
    edit?  # Использовать ту же логику, что и для edit
  end

  def destroy?
    edit?  # Использовать ту же логику, что и для edit
  end

end

