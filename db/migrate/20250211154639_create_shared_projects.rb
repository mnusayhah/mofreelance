class CreateSharedProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_projects do |t|
      t.references :project, null: false, foreign_key: true
      t.references :freelancer, null: false, foreign_key: { to_table: :users }
      t.integer :status

      t.timestamps
    end
  end
end
