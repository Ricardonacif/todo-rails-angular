class Task < ActiveRecord::Base
  default_scope { order('sort_order DESC') } 

  belongs_to :user, counter_cache: true
  has_many :sub_tasks, dependent: :destroy
  
  validates_presence_of :body

  before_create :set_sort_order

  def set_sort_order
    last_task = user.tasks.last
    self.sort_order = last_task ? last_task.sort_order + 1 : 1
  end



end