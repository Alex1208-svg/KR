class CreateGrades < ActiveRecord::Migration[6.1]
def change
  create_table :grades do |t|
    t.boolean :status, default: false  # Зачтено или нет
    t.references :student, null: false, foreign_key: { to_table: :users }
    t.references :post, null: false, foreign_key: true

    t.timestamps
  end
end
end

