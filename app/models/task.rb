class Task < ActiveRecord::Base
  default_scope { order('sort_order DESC') } 

  scope :with_sub_tasks, -> { includes(:sub_tasks)}
  scope :public_tasks, -> { where(public: true)}
  belongs_to :user, counter_cache: true

  has_many :sub_tasks, dependent: :destroy
  accepts_nested_attributes_for :sub_tasks, allow_destroy: true
  
  validates_presence_of :body

  before_create :set_sort_order

  def set_sort_order
    last_task = user.tasks.first
    self.sort_order = last_task ? last_task.sort_order + 1 : 1
  end

end