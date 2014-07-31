require 'rails_helper'

RSpec.describe SubTask, :type => :model do
  subject { FactoryGirl.create(:sub_task) }
  
  context "Validations" do 

    [:body, :task_id].each do |attribute|

      it "should not be valid without #{attribute}" do 
        subject.send("#{attribute}=", '')
        expect(subject).not_to be_valid
      end
    end

  end

  it "completed should be false by default" do
    expect(subject.completed).to be_equal(false)
  end

  it "should update parent task updated_at field when updated" do
    updated_at = subject.task.updated_at
    subject.update(body: 'Updating this sub task')
    expect(subject.task.updated_at).not_to be_equal(updated_at)
  end

  it "should update parent task's counter_cache" do
    task = subject.task
    counter = task.reload.sub_tasks_count
    FactoryGirl.create(:sub_task, task: subject.task)
    expect(task.reload.sub_tasks_count).to be_equal(counter + 1)
  end

  it "should increment sort_order when creating another subtask of the same task" do
    task = subject.task
    other_sub_task = FactoryGirl.create(:sub_task, task: task)
    expect(other_sub_task.sort_order).to be_equal(subject.sort_order + 1)
  end

  it "should load the task's subtasks on descending order using the field sort_order by default" do
    task = subject.task
    other_sub_task = FactoryGirl.create(:sub_task, task: task)
    expect(task.sub_tasks.first.id).to be_equal(other_sub_task.id)
  end


end