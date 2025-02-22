class AddDefaultStatusToProjects < ActiveRecord::Migration[7.1]
  def change
    change_column_default :projects, :status, 0  # Default to 'open' (0)
  end
end
