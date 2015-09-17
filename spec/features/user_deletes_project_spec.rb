require 'rails_helper'

feature 'user deletes project' do
  context 'authenticated user' do
    scenario 'successfully' do
      user = FactoryGirl.build(:user)
      sign_in_as user

      project = FactoryGirl.create(
        :blank_project,
        description: "Old boring description",
        creator_id: User.find_by(email: user.email).id
      )

      visit projects_path
      within("#project-#{project.id}") do
        find(:css, "#delete_project_#{project.id}").click
      end

      expect(page.source).to match('Successfully deleted project.')
    end
  end
end
