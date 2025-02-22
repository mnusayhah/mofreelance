class RemoveSkillsFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :skills, :string
  end
end
