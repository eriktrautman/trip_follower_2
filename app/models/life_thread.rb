class LifeThread < ActiveRecord::Base
  attr_accessible :name, :tagline, :description, :s_date, :e_date, :hashtag

  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  validates :name, length: { in: 4..24 }
  
end
