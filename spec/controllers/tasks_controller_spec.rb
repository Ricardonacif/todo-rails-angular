require 'rails_helper'


RSpec.describe TasksController, :type => :controller do

  let(:valid_attributes) {
    FactoryGirl.create(:task).attributes
  }

  context "when logged out" do 
    it "should not be able to access index" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end


    it "should not be able to create a new task" do
      xhr :post, :create, task: valid_attributes
      expect(response.status).to be_equal(302)
    end

    { post: :update, delete: :destroy}.each_pair do |method, action|
      it "should not be able to access #{action}" do
        xhr method, action, id: valid_attributes['id']
        expect(response.status).to be_equal(302)
      end
    end

  end
  
  context "when logged in" do
    login_user_before_each
    describe "#index" do 
    
      it "should render the html page" do
        get :index
        expect(response).to render_template("index")
      end

      it "should send the current_user's tasks as json" do
        FactoryGirl.create(:task, user_id: @current_user.id)
        xhr :get, :index, format: :json
        json = JSON.parse response.body
        expect(response.content_type).to include("json")
        expect(json).to be_a(Array)
      end

    end

    describe "#create" do 
      it "should create a new task for the current user" do 
        expect {
          xhr :post, :create, format: :json, task: valid_attributes
          }.to change(@current_user.tasks, :count).by(1)
      end

      it "should not create a task for another user" do
        modified_valid_attributes = valid_attributes
        modified_valid_attributes['id'] = @current_user.id + 2
        expect {
          xhr :post, :create, format: :json, task: valid_attributes
          }.to change(@current_user.tasks, :count).by(1)
      end
    end

    describe "#update" do 
      it "should update the task" do 
        task = FactoryGirl.create(:task, user_id: @current_user.id)
        xhr :post, :update, format: :json, id: task.id, task: {body: "New body"}
        expect(task.reload.body).to include("New body")
      end

      it "should not change the user_id of the task" do
        task = FactoryGirl.create(:task, user_id: @current_user.id)
        xhr :post, :update, format: :json, id: task.id, task: {user_id: @current_user.id + 1}
        expect(task.reload.user_id).to be_equal(@current_user.id)
      end
    end

    describe "#destroy" do 
      it "should destroy the task" do 
        task = FactoryGirl.create(:task, user_id: @current_user.id)
        expect {
          xhr :delete, :destroy, format: :json, id: task.id
          }.to change(@current_user.tasks, :count).by(-1)
      end

      it "should not destroy other user's task" do
        task = FactoryGirl.create(:task)
        expect {
          xhr :delete, :destroy, format: :json, id: task.id
          }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end
end