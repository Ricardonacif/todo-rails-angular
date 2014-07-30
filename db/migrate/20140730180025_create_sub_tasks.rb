class CreateSubTasks < ActiveRecord::Migration
  def change
    create_table :sub_tasks do |t|
      t.string :body
      t.belongs_to :task, index: true

      t.timestamps
    end
  end
end
