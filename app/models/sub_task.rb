class SubTask < ActiveRecord::Base
  belongs_to :task
  validates_presence_of :body, :task_id
end
