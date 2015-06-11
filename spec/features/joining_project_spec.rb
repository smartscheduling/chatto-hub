require 'rails_helper'

feature 'other users can join a project' do
  before :each do
    FactoryGirl.create(:project, name: 'Opiate Prediction')
  end

  context 'as an authenticated user' do
    let(:user) { FactoryGirl.create(:user) }

    scenario 'successfully' do
      sign_in_as(user)

      visit projects_path
      click_on 'Join Project'

      expect(page).to have_content('Successfully joined project')
    end
  end

  context 'as a visitor' do
    scenario 'I get prompted to create an account or sign in' do
      visit projects_path
      click_on 'Join Project'
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
