#encoding: UTF-8
require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!


RSpec.describe "Tasks Index", :type => :feature, :js => true do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

  after(:each) do 
    Warden.test_reset! 
  end

  def create_a_task body = "My new task"
    visit '/tasks'
    fill_in 'new_task', with: body
    find('#new_task').native.send_keys(:return)
  end

  def create_a_subtask body = "My new Subtask :D"
    create_a_task
    click_button "(0) Manage Subtasks"
    fill_in 'new_sub_task', with: body
    find('#new_sub_task').native.send_keys(:return)
  end

  it "create a task successfully" do
    expect{
      create_a_task
    }.to change(Task, :count).by(1)
    expect(page).to have_content("My new task")

  end

  it "mark the task as completed" do
    create_a_task
    first("input[type='checkbox']").set(true)
    sleep(2)
    expect(Task.last.completed).to be_equal(true)
  end

  it "mark the task as public" do
    create_a_task
    all("input[type='checkbox']").last.set(true)
    expect(Task.last.public).to be_equal(true)
  end

  it "edit a task" do
    create_a_task 'Nice task'
    click_link 'Nice task'
    first(:css, ".editable-input").set('My new body yeah!')
    first(:css, ".editable-input").native.send_keys(:return)
    sleep(2)
    expect(Task.last.body).to include('My new body yeah!')
  end

  it "delete a task" do
    create_a_task
    expect{
      click_button "Remove"
    }.to change(Task, :count).by(-1)
  end


  it "add subtasks" do
    expect{
      create_a_subtask "My new Subtask :D"
    }.to change(SubTask, :count).by(1)
    expect(page).to have_content("Editing Task")
    expect(page).to have_content("My new Subtask :D")
  end

  it "edit a task" do
    create_a_subtask 'Nice subtask'
    click_link 'Nice subtask'
    first(:css, ".editable-input").set('My new body yeah!')
    first(:css, ".editable-input").native.send_keys(:return)
    sleep(2)
    expect(SubTask.last.body).to include('My new body yeah!')
  end
  
  it "delete subtasks" do
    create_a_subtask
    expect{
      click_button "Remove SubTask"  
      }.to change(SubTask, :count).by(-1)
  end

end