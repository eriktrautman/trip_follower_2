class Event < ActiveRecord::Base
  attr_accessible :name, :date, :hashtag, :creator_id, :life_thread_id

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :life_thread

  validates :name, length: { in: 1..16 }
  validates :hashtag, length: { in: 1..64 }
  validates :creator_id, presence: true
  validates :life_thread_id, presence: true

  
end
