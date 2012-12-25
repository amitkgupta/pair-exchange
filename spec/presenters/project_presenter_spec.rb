require 'spec_helper'

describe ProjectPresenter do
	it "includes id name, description, office, technology" do
		project = Project.new(
			name: 'foo',
			description: 'a fun project',
			office: 'SF',
			technology: 'rails',
		)
		
		presented_project = described_class.new(project)
		
		presented_project.id.should == project.id
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
	
	describe "ownership and interests" do
		let!(:project) { Project.new(owner: friendly_user) }

		context "when a current user is given" do			
			context "and the user owns the project" do
				it "presents that said user owns the project" do
					described_class.new(project, friendly_user).current_user_owns.should == true
				end
			end
			
			context "and the user doesn't own the project" do
				it "presents that said user doesn't own the project" do
					described_class.new(project, loner).current_user_owns.should == false
				end
			end

			context "and the user is interested in the project" do
				it "presents that said is interested in the project" do
					Interest.create(project, friendly_user)
					
					described_class.new(project, friendly_user).current_user_interested.should == true
				end
			end
			
			context "and the user is not interested in the project" do
				it "presents that said isn't interested in the project" do
					friendly_user.interests.should_not include(project)
				
					described_class.new(project, loner).current_user_interested.should == false
				end
			end
		end
		
		context "when a current user is not given" do
			it "leaves the ownership and interest fields blank" do
				presented_project = described_class.new(project)
				
				presented_project.current_user_owns.should be_blank
				presented_project.current_user_interested.should be_blank
			end
		end
	end
end