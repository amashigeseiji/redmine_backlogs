class RbProjectSettings < ActiveRecord::Base
  unloadable
  belongs_to :project
  validates :calculate_sprint_name, presence: true, if: "!calculate_with_other_project.empty?"
  validate :calculate_with_other_project, -> {
    calculate_with_other_project.split(',').each do |identifier|
      errors.add(:calculate_with_other_project, "project does not found. identifier: " + identifier) unless Project.exists?(identifier: identifier)
    end
  }
end

