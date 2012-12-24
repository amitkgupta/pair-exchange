FactoryGirl.define do
  factory :user do
    sequence :google_id
    email 'factory.girl@pivotallabs.com'
  end
end