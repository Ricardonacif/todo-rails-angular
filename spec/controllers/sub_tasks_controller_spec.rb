require 'rails_helper'


RSpec.describe SubTasksController, :type => :controller do

  let(:valid_attributes) {
    FactoryGirl.create(:sub_task).attributes
  }

  context "when logged out" do 

    it "should not be able to create a new task" do
      xhr :post, :create, task_id: valid_attributes['task_id'] , sub_task: valid_attributes
      expect(response.status).to be_equal(302)
    end

    { post: :update, delete: :destroy}.each_pair do |method, action|
      it "should not be able to access #{action}" do
        xhr method, action, task_id: valid_attributes['task_id'] , id: valid_attributes['id']
        expect(response.status).to be_equal(302)
      end
    end

  end
  
  context "when logged in" do
    login_user_before_each
    let(:valid_attributes) {
      @task = FactoryGirl.create(:task, user_id: @current_user.id)
      FactoryGirl.build(:sub_task, task: @task).attributes
    }

    describe "#create" do 
      it "should create a new sub_task for the current user" do 
        expect {
          xhr :post, :create, format: :json, task_id: valid_attributes['task_id'], sub_task: valid_attributes
          }.to change(@current_user.sub_tasks, :count).by(1)
      end
    end

    describe "#update" do 
      it "should update the sub_task" do 
        task = FactoryGirl.create(:task, user_id: @current_user.id)
        sub_task = FactoryGirl.create(:sub_task, task: task)
        xhr :post, :update, format: :json,task_id: sub_task.task_id, id: sub_task.id, sub_task: {body: "New nice body"}
        expect(sub_task.reload.body).to include("New nice body")
      end

    end

    describe "#destroy" do 
      it "should destroy the task" do
        task = FactoryGirl.create(:task, user_id: @current_user.id)
        sub_task = FactoryGirl.create(:sub_task, task: task)
        expect {
          xhr :delete, :destroy, format: :json,task_id: sub_task.task_id, id: sub_task.id
          }.to change(@current_user.sub_tasks, :count).by(-1)
      end
    end
  end
end