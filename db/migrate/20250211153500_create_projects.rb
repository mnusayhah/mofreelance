class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :budget
      t.string :status
      t.string :required_skills
      t.string :visibility
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
