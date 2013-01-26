require 'spec_helper'

describe "Markdown", js: true do
	it "accepts markdown when on the project form and displays it properly on the project index" do
		login_user
		
		click_on "Add project"
		fill_in "Description", with: "[foo](https://www.youtube.com/watch?v=7rE0-ek6MZA)

**bold text**

~~~.ruby
my_long_variable_name = Math.PI
~~~"
		click_on "Create Project"
		
		within('.description') do
			page.should have_css('p', count: 2)
			page.find('a')['href'].should == "https://www.youtube.com/watch?v=7rE0-ek6MZA"
			page.find('strong').text.should == "bold text"
			
			page.should have_css('pre', count: 1)
			page.find('code.ruby').text.should == "my_long_variable_name = Math.PI"
		end
	end
end