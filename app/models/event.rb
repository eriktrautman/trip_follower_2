class Event < ActiveRecord::Base
  attr_accessible :name, :date, :hashtag, :creator_id, :trip_id, :tagline

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :trip

  validates :name, length: { in: 1..24 }
  validates :name, presence: true
  validates :hashtag, length: { in: 1..64 }, allow_blank: false
  validates :hashtag, presence: true
  validates :creator_id, presence: true
  validates :trip_id, presence: true
  validates :tagline, length: { maximum: 140 }, allow_blank: true

end
