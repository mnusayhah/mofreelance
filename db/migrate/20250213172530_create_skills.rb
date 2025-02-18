class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.string :job_title
      t.string :company
      t.date :start_date
      t.date :end_date
      t.text :description
      t.string :localisation
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
