class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :address
      t.text :bio
      t.integer :years_of_experience
      t.string :skills
      t.string :portfolio_url
      t.decimal :hourly_rate
      t.string :availability_status
      t.string :language

      t.timestamps
    end
  end
end
