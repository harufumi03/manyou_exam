class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  enum priority: [ "低", "中", "高" ]
  enum status: [ "未着手", "着手中", "完了" ]
  
  scope :sort_deadline_on, -> {order(deadline_on: :asc)}
  scope :sort_priority, -> {order(priority: :desc)}

  scope :created, -> {order(created_at: "DESC")}

  scope :title, -> (title) {where("title like ?", "%#{title}%")}
  scope :status, -> (status) { where(status: status) }
  scope :label, ->(label) { where(id: TaskLabel.where(label_id: label).select(:task_id))}
  scope :title_status, -> (title, status) {where("title like ?", "%#{title}%").where(status: status)}
  
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
end
