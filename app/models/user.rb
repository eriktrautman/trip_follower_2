class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation,

  has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :create_session_token

  has_many :trips, foreign_key: :creator_id, dependent: :destroy
  has_many :events, foreign_key: :creator_id, dependent: :destroy

  # Admin and Whitelisting Associations
  has_many :trip_adminships, class_name: "TripAdministratoring", foreign_key: :user_id, dependent: :destroy
  has_many :administrated_trips, through: :trip_adminships, source: :trip
  has_many :trip_whitelistings, dependent: :destroy
  has_many :whitelisted_trips, through: :trip_whitelistings,
  		source: :trip

  # User Following Associations
  has_many :user_followings, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :user_followings

  has_many :reverse_user_followings, class_name: "UserFollowing", foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :reverse_user_followings, source: :following_user

  # Trip Subscription Associations
  has_many :trip_subscriptions, foreign_key: :subscriber_id
  has_many :subscribed_trips, through: :trip_subscriptions, source: :trip


  # VALIDATIONS
  [ :username, :email, :password, :password_confirmation ].each do |field| validates field, presence: true
  end
	validates :username, length: { maximum: 24,
					message: "Name lengths must be between 2-24 characters"  }
	validates :username, uniqueness: { case_sensitive: false }
	validates :password, length: { in: 6..16,
					message: "Password lengths must be between 6-16 characters"  }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	def administrates(trip) # SHOULD BE QUESTION MARK METHOD
		self.administrated_trips.include?(trip)
	end

	def following?(other_user)
		self.followed_users.include?(other_user)
	end

	def follow!(other_user)
		self.user_followings.create!(followed_id: other_user.id)
    other_user.trips.each do |trip|
      unless self.subscribed_trips.include?(trip)
        trip.subscribe!(self)
      end
    end
	end

	def unfollow!(other_user)
		UserFollowing.find_by_followed_id(other_user.id).destroy
    other_user.trips.each do |trip|
      if self.subscribed_trips.include?(trip)
        trip.unsubscribe(self)
      end
    end
	end

  def subscribed_to?(trip)
    self.subscribed_trips.include?(trip)
  end

  def subscribe_followers_to(trip)
    self.followers.each do |follower|
      unless follower.subscribed_trips.include?(trip)
        trip.subscribe(follower)
      end
    end
  end


	private
		def create_session_token
			self.session_token = SecureRandom.urlsafe_base64
		end


end
