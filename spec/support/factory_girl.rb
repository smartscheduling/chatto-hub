require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  factory :project do
    sequence(:name) {|n| "Smart Scheduling#{n}"}
    description 'An app for scheduling efficiency'
    before :create do |proj|
      proj.creator = FactoryGirl.create(:user)
    end
  end
end


