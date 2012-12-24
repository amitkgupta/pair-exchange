require 'spec_helper'

describe User do
	pending { should have_many(:projects) }	
	pending { should validate_uniqueness_of(:google_id) }
	pending { should validate_presence_of(:google_id) }
end
