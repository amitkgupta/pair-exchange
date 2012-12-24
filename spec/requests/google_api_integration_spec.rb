require 'spec_helper'

describe 'Google API Integration', js: true do
	it "should display project owners' G+ profile pictures near their pictures" do
		pending "Assumptions about how we could interact with Google+ API need refactoring"
		
		Project.create(name: 'The Projective Hierarchy', owner: 'testing.pair.exchange@gmail.com')
		Project.create(name: 'Orthogonal Projections', owner: 'amitkgupta84@gmail.com')
		
		login_test_user
		
		image_sources = page.all('tr')[1..-1].map do |row|
			row.find('img')['src']
		end
		
		image_sources.uniq.count.should == 2
		
		image_sources.each do |source| 
			source.should include('.googleusercontent.com/')
			source.should include('/photo.jpg?sz=50')
		end
	end
end