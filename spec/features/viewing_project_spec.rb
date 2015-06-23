require 'rails_helper'

feature 'viewing projects' do
  context 'as an authenticated user' do
    scenario 'I can view a projects individual page' do
      user = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)
      sign_in_as user

      click_on 'Browse Projects'
      click_link project.name
      expect(page).to have_content(project.description)
      expect(page).to have_content(project.name)
    end

    scenario 'I have the option to join a project if I want' do

    end
  end

  context 'as a visitor' do

  end
end
