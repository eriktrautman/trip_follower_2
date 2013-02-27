class Trip < ActiveRecord::Base
  attr_accessible :name, :tagline, :description, :s_date, :e_date, :hashtag, :whitelist_posters, :public_view

  # Basic Associations
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  has_many :events, dependent: :destroy
  has_many :trip_administratorings, dependent: :destroy
  has_many :admins, through: :trip_administratorings, source: :user

  # Whitelisting Associations

  # REV: I think you should just name the association `whitelistings`;
  # you only need to use `:class_name => "TripWhitelistings"` for that
  # to work.
  has_many :trip_whitelistings, dependent: :destroy
  has_many :whitelisted_users, through: :trip_whitelistings, source: :user

  # Trip Subscription Associations
  has_many :trip_subscriptions, foreign_key: :trip_id
  has_many :subscribed_users, through: :trip_subscriptions, source: :user

  # VALIDATIONS
  validates :name, length: { in: 4..24 }
  validates :name, presence: true
  validates :tagline, length: { maximum: 140 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :hashtag, length: { in: 1..64 }
  validates :hashtag, presence: true

  validate :validate_end_date_after_start_date

  def remove_admin(user)
    # REV: I'd use `find_by_user_id` here.
    self.trip_administratorings.where("user_id = ?", user.id).first.destroy
  end

  def remove_whitelisting(user)
    self.trip_whitelistings.where("user_id = ?", user.id).first.destroy
  end

  # REV: not sure you need this: `trip.subscribed_users << user`
  def subscribe(user)
    self.trip_subscriptions.create(user: user)
  end

  def subscribe!(user)
    self.trip_subscriptions.create!(user: user)
  end

  def unsubscribe(user)
    self.trip_subscriptions.where("subscriber_id = ?", user.id).first.destroy
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
