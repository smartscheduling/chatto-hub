require "rails_helper"

feature "editing projects" do
  context "authenticated user" do
    scenario "successfully change description" do
      user = FactoryGirl.build(:user)
      sign_in_as user

      project = FactoryGirl.create(
        :blank_project,
        description: "Old boring description",
        creator_id: User.find_by(email: user.email).id
      )

      visit projects_path
      find(:css, "#edit_project_#{project.id}").click

      fill_in "Description", with: "New cool description"
      click_on "Update"

      expect(page.source).to match("Successfully updated project")
      expect(page).to have_content("New cool description")
    end
  end
end
