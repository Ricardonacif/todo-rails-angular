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



#   let(:invalid_attributes) {
#     skip("Add a hash of attributes invalid for your model")
#   }

#   let(:valid_session) { {} }

#   describe "GET index" do
#     it "assigns all tasks as @tasks" do
#       task = Task.create! valid_attributes
#       get :index, {}, valid_session
#       expect(assigns(:tasks)).to eq([task])
#     end
#   end

#   describe "GET show" do
#     it "assigns the requested task as @task" do
#       task = Task.create! valid_attributes
#       get :show, {:id => task.to_param}, valid_session
#       expect(assigns(:task)).to eq(task)
#     end
#   end

#   describe "GET new" do
#     it "assigns a new task as @task" do
#       get :new, {}, valid_session
#       expect(assigns(:task)).to be_a_new(Task)
#     end
#   end

#   describe "GET edit" do
#     it "assigns the requested task as @task" do
#       task = Task.create! valid_attributes
#       get :edit, {:id => task.to_param}, valid_session
#       expect(assigns(:task)).to eq(task)
#     end
#   end

#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new Task" do
#         expect {
#           post :create, {:task => valid_attributes}, valid_session
#         }.to change(Task, :count).by(1)
#       end

#       it "assigns a newly created task as @task" do
#         post :create, {:task => valid_attributes}, valid_session
#         expect(assigns(:task)).to be_a(Task)
#         expect(assigns(:task)).to be_persisted
#       end

#       it "redirects to the created task" do
#         post :create, {:task => valid_attributes}, valid_session
#         expect(response).to redirect_to(Task.last)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved task as @task" do
#         post :create, {:task => invalid_attributes}, valid_session
#         expect(assigns(:task)).to be_a_new(Task)
#       end

#       it "re-renders the 'new' template" do
#         post :create, {:task => invalid_attributes}, valid_session
#         expect(response).to render_template("new")
#       end
#     end
#   end

#   describe "PUT update" do
#     describe "with valid params" do
#       let(:new_attributes) {
#         skip("Add a hash of attributes valid for your model")
#       }

#       it "updates the requested task" do
#         task = Task.create! valid_attributes
#         put :update, {:id => task.to_param, :task => new_attributes}, valid_session
#         task.reload
#         skip("Add assertions for updated state")
#       end

#       it "assigns the requested task as @task" do
#         task = Task.create! valid_attributes
#         put :update, {:id => task.to_param, :task => valid_attributes}, valid_session
#         expect(assigns(:task)).to eq(task)
#       end

#       it "redirects to the task" do
#         task = Task.create! valid_attributes
#         put :update, {:id => task.to_param, :task => valid_attributes}, valid_session
#         expect(response).to redirect_to(task)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns the task as @task" do
#         task = Task.create! valid_attributes
#         put :update, {:id => task.to_param, :task => invalid_attributes}, valid_session
#         expect(assigns(:task)).to eq(task)
#       end

#       it "re-renders the 'edit' template" do
#         task = Task.create! valid_attributes
#         put :update, {:id => task.to_param, :task => invalid_attributes}, valid_session
#         expect(response).to render_template("edit")
#       end
#     end
#   end

#   describe "DELETE destroy" do
#     it "destroys the requested task" do
#       task = Task.create! valid_attributes
#       expect {
#         delete :destroy, {:id => task.to_param}, valid_session
#       }.to change(Task, :count).by(-1)
#     end

#     it "redirects to the tasks list" do
#       task = Task.create! valid_attributes
#       delete :destroy, {:id => task.to_param}, valid_session
#       expect(response).to redirect_to(tasks_url)
#     end
#   end

end
