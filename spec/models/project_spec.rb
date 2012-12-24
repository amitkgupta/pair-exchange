require 'spec_helper'

describe Project do
  pending { should belong_to(:owner) }
  pending { should validate_presence_of(:owner) }
  pending { should allow_mass_assignment_of(:owner) }

  describe '.active' do
    let!(:finished_project) { Project.create(owner: friendly_user, finished: true) }
    let!(:active_project) { Project.create(owner: friendly_user, finished: false) }

    it 'contains only active projects' do
      Project.active.should include(active_project)
      Project.active.should_not include(finished_project) 
    end
  end
end