class SubTask < ActiveRecord::Base
  default_scope { order('sort_order DESC') }
  
  validates_presence_of :body, :task_id

  belongs_to :task, counter_cache: true, touch: true

before_create :set_sort_order
  
  def set_sort_order
    last_sub_task = task.sub_tasks.last
    self.sort_order = last_sub_task ? last_sub_task.sort_order + 1 : 1
  end

end