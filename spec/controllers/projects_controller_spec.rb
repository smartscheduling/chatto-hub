require "rails_helper"

describe ProjectsController do
  describe "GET #new" do
    context "when user is logged in" do
      login_user

      before { get :new }

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :new }
    end
  end

  describe "POST #create" do
    login_user

    context "when valid project form" do
      before do
        allow_any_instance_of(ProjectForm).
          to receive(:save).and_return(true)
        post :create, project_form: { name: '', description: '' }
      end

      it { is_expected.to redirect_to projects_path }
    end

    context "when invalid project form" do
      before do
        allow_any_instance_of(ProjectForm).
          to receive(:save).and_return(false)
        post :create, project_form: { name: '', description: '' }
      end

      it { is_expected.to render_template :new }
    end
  end
end
