FactoryGirl.define do
  factory :project do
    name 'Farnsworth'
    association :owner, :factory => :user
  end
end