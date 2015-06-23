require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "users-chatto#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    nickname 'Spence'
    first_name 'Spencer'
  end

  factory :project do
    sequence(:name) {|n| "Smart Scheduling#{n}"}
    description 'An app for scheduling efficiency'
    before :create do |proj|
      proj.creator = FactoryGirl.create(:user)
      proj.channel_id = 'SKJFJE@#'
      proj.url = 'www.slack.com'
    end
  end
end


