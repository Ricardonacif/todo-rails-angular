require 'rails_helper'

RSpec.describe Task, :type => :model do
  subject { FactoryGirl.create(:task) }
  context "Validations" do 

    it "should validate the presence of body" do
      subject.body = ''
      expect(subject).not_to be_valid
    end

  end

  it "public should be false by default" do
    expect(subject.public).to be_equal(false)
  end

  it "completed should be false by default" do
    expect(subject.completed).to be_equal(false)
  end

  it "should update users counter_cache when created" do
    user = subject.user
    counter = user.reload.tasks_count
    FactoryGirl.create(:task, user: user)
    expect(user.reload.tasks_count).to be_equal(counter + 1)
  end

  it "should increment sort_order when creating another task of the same user" do
    user = subject.user
    other_task = FactoryGirl.create(:task, user: user)
    expect(other_task.sort_order).to be_equal(subject.sort_order + 1)
  end

  it "should load a user's tasks on descending order using the field sort_order by default" do
    user = subject.user
    other_task = FactoryGirl.create(:task, user: user)
    expect(user.tasks.first.id).to be_equal(other_task.id)
  end


end