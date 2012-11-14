require 'spec_helper'

describe Project do
  describe '.active' do
    let!(:finished_project) { create(:project, name: 'Finished', finished: true) }
    let!(:active_project) { create(:project, name: 'Active', finished: false) }

    it 'contains only active projects' do
      Project.active.should include(active_project)
      Project.active.should_not include(finished_project) 
    end
  end
  
  describe '#interest_from?' do
    it 'should return true for interested users' do
      project = FactoryGirl.create :project
      interest = project.interests.create :user => "testUser@example.com"
      project.interest_from?("testUser@example.com").should be_true
    end

    it 'should return false for not interested users' do
      project = FactoryGirl.create :project
      interest = project.interests.create :user => "testUser@example.com"
      project.interest_from?("notInterested@example.com").should be_false
    end
  end

  describe '#owner_image_url' do
    it 'gets the image url from the google api' do

    end
  end
end