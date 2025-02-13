class CreateEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :educations do |t|
      t.string :school
      t.string :diploma
      t.date :start_date
      t.date :end_date
      t.string :localisation
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
