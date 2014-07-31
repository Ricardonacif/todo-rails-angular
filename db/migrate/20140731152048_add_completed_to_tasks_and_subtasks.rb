class AddCompletedToTasksAndSubtasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed, :boolean, default: false
    add_column :sub_tasks, :completed, :boolean, default: false
  end
end
