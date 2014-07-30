class AddOrderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :sort_order, :integer
    add_column :sub_tasks, :sort_order, :integer
  end
end
