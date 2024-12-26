# app/models/performance.rb
class Performance < ApplicationRecord
  belongs_to :user

  validates :subject, presence: true
  validates :grade, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end

