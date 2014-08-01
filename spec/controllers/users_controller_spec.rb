require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
    
  describe "#index" do 
    context "when logged out" do 

      it "should redirect to sign in" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do 
      login_user_before_each
      
      it "should render page with users" do
        get :index
        expect(response).to render_template("index")
        expect(assigns(:users)).to be_present
      end

    end
  end

  describe "#show" do 
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    context "when logged out" do 
      
      it "should redirect to sign in" do
        get :show, id: @user.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do 
      login_user_before_each
      
      it "should redirect if user doesn't have any public task" do
        FactoryGirl.create(:task, user: @user)
        get :show, id: @user.id
        expect(response).to redirect_to(users_path)
      end

      it "should list the users public tasks only" do
        FactoryGirl.create(:task, user: @user, public: true)
        FactoryGirl.create(:task, user: @user, public: false)
        get :show, id: @user.id
        expect(response).to render_template("show")
        expect(assigns(:user).tasks.size).to be_equal(1)
      end
    end

  end
end