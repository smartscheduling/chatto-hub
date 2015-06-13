require 'rails_helper'

feature 'other users can join a project' do
  context 'as an authenticated user' do
    let(:user_of_project) { FactoryGirl.create(:user, email: 'spencer@smartscheduling.io') }
    let(:user_joining) { FactoryGirl.create(:user) }

   scenario 'successfully' do
      # VCR.use_cassette("slack_invite") do
        # sign_in_as(user_joining)

        # # project_params = { name: "Chatto-9" }
        # # CreateProject.new(user_of_project, project_params).perform

        # visit projects_path
        # click_on 'Join Project'

        # expect(page).to have_content('Successfully joined project')
      # end
    end
  end

  context 'as a visitor' do
    scenario 'I get prompted to create an account or sign in' do
      FactoryGirl.create(:project)
      visit projects_path
      click_on 'Join Project'
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
