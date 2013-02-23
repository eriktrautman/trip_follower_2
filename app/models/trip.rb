class Trip < ActiveRecord::Base
  attr_accessible :name, :tagline, :description, :s_date, :e_date, :hashtag

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :events

  validates :name, length: { in: 4..24 }
  validates :name, presence: true
  validates :tagline, length: { maximum: 140 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :hashtag, length: { in: 1..64 }
  validates :hashtag, presence: true

  validate :validate_end_date_after_start_date


  private

  def validate_end_date_after_start_date
    if self.e_date && self.s_date
      if e_date < s_date
        errors.add(:e_date, "End date must be after the start date")
      end
    end
  end
end
