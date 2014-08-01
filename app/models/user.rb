class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  scope :with_public_tasks, -> { includes(:tasks).includes(tasks: :sub_tasks).where(tasks: {public: true})}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name

  has_many :tasks, dependent: :destroy
  has_many :sub_tasks, through: :tasks
end