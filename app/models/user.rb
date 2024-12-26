# app/models/user.rb
class User < ApplicationRecord
  validates :full_name, presence: true, length: { maximum: 100 }
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, omniauth_providers: [:google_oauth2]

  enum role: {admin: 'admin', teacher: 'teacher', student: 'student' } # Переименовали роли

  validate :admin_cannot_be_assigned_in_form, on: :create
  after_initialize :set_default_role, if: :new_record?

  # Проверка, является ли пользователь админом или преподавателем
  def admin_or_teacher?
    admin? || teacher?
  end

  def likes?(post)
    likes.exists?(post_id: post.id)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

  has_many :posts
  has_many :likes
  has_many :grades, foreign_key: :student_id
  has_many :posts, dependent: :destroy  # Удаление постов вместе с пользователем
  has_many :likes, dependent: :destroy # Удаление лайков вместе с пользователем

  private

  def set_default_role
    self.role ||= :student
  end

  def admin_cannot_be_assigned_in_form
    if role == 'admin'
      errors.add(:role, 'не может быть admin через интерфейс.')
    end
  end
end
