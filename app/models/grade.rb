class Grade < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :post

  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # Метод для проверки зачтённого статуса
  def passed?
    score.present? && score >= 20
  end
end

