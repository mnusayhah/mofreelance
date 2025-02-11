class CreateDiscussions < ActiveRecord::Migration[7.1]
  def change
    create_table :discussions do |t|
      t.references :project, null: false, foreign_key: true
      t.references :freelancer, null: false, foreign_key: { to_table: :users }
      t.references :enterprise, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
