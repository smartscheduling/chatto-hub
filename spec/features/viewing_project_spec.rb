require 'rails_helper'

feature 'viewing projects' do
  context 'as an authenticated user' do
  end

  context 'as a visitor' do
    scenario 'I can view a list of projects' do
      FactoryGirl.create(:project, name: 'Smart Scheduling')
      visit projects_path
      expect(page).to have_content('Smart Scheduling')
    end
  end
end
