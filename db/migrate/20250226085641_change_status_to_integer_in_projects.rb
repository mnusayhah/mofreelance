class ChangeStatusToIntegerInProjects < ActiveRecord::Migration[7.1]
  def change
    change_column :projects, :status, :integer, default: 0, null: false, using: 'status::integer'
  end
end
