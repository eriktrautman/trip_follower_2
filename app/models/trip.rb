class Trip < ActiveRecord::Base
  attr_accessible :name, :tagline, :description, :s_date, :e_date, :hashtag, :whitelist_posters, :public_view

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :events, dependent: :destroy
  has_many :trip_administratorings, dependent: :destroy
  has_many :admins, through: :trip_administratorings, source: :user
  has_many :trip_whitelistings, dependent: :destroy
  has_many :whitelisted_users, through: :trip_whitelistings, source: :user

  validates :name, length: { in: 4..24 }
  validates :name, presence: true
  validates :tagline, length: { maximum: 140 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :hashtag, length: { in: 1..64 }
  validates :hashtag, presence: true

  validate :validate_end_date_after_start_date

  def remove_admin(user)
    self.trip_administratorings.where("user_id = ?", user.id).first.destroy
  end

  def remove_whitelisting(user)
    self.trip_whitelistings.where("user_id = ?", user.id).first.destroy
  end

  private

  def validate_end_date_after_start_date
    if self.e_date && self.s_date
      if e_date < s_date
        errors.add(:e_date, "End date must be after the start date")
      end
    end
  end
end
