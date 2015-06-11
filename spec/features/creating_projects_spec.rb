require 'rails_helper'

feature "creating projects" do
  context "as a signed in user" do
    scenario "I can create a project" do
      user = FactoryGirl.create(:user)
      sign_in_as(user)

      visit new_project_path

      fill_in 'Name', with: 'Smart Scheduling'
      click_on 'Create Project'

      expect(page).to have_content('Successfully created project.')
      expect(Project.count).to be 1
    end
  end

  context "as a visitor" do
    scenario "it redirects me to login page" do
      visit root_path
      click_on 'New Project'

      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end

