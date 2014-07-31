class AddCounterCacheToUserAndTasks < ActiveRecord::Migration
  def change
    add_column :users, :tasks_count, :integer, default: 0
    add_column :tasks, :sub_tasks_count, :integer, default: 0
  end
end
