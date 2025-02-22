class AddTechSkillsToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :tech_skills, :string
  end
end
