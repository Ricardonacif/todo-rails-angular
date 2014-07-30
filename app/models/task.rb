class Task < ActiveRecord::Base
  has_many :sub_tasks
  validates_presence_of :body
end
