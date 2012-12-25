require 'spec_helper'

describe ProjectPresenter do
	it "includes name, description, office, technology" do
		project = Project.new(
			name: 'foo',
			description: 'a fun project',
			office: 'SF',
			technology: 'rails',
		)
		
		presented_project = described_class.new(project)
				
		presented_project.name.should == 'foo'
		presented_project.description.should == 'a fun project'
		presented_project.office.should == 'SF'
		presented_project.technology.should == 'rails'
	end
	
	describe "presented owner" do
		context "when the project is new and doesn't have an owner" do
			it "the presented project should not have an owner" do
				described_class.new(Project.new).owner.should be_blank
			end
		end
		
		context "when the project has an owner" do
			it "the presented project should have a presented owner" do
				owner = User.new(email: "foo@bar.com")
				described_class.new(Project.new(owner: owner)).owner.should be_a(UserPresenter)
			end
		end
	end
end