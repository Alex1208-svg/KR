class GradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @students = User.includes(:grades)
                    .where(role: :student)
                    .map do |student|
      {
        student: student,
        average_score: student.grades.average(:score).to_f.round(2),
        passed_posts_count: student.grades.where(status: true).count
      }
    end
                    .sort_by { |data| -data[:average_score] } # Сортировка по убыванию среднего балла
  end
end

