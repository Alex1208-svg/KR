class CreatePerformances < ActiveRecord::Migration[7.0]
  def change
    create_table :performances do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.integer :grade
      t.text :comment

      t.timestamps
    end
  end
end
