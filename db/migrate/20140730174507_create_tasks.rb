class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :body
      t.boolean :public, default: :false
      t.timestamps
    end
  end
end
