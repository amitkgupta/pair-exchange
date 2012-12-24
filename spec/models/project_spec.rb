require 'spec_helper'

describe Project do
  pending { should belong_to(:user) }
  pending { should validate_presence_of(:user) }
  
  describe '.active' do
    let!(:finished_project) { create(:project, name: 'Finished', finished: true) }
    let!(:active_project) { create(:project, name: 'Active', finished: false) }

    it 'contains only active projects' do
      Project.active.should include(active_project)
      Project.active.should_not include(finished_project) 
    end
  end
end