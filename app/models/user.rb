class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation,

  has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :create_session_token

  has_many :trips, foreign_key: :creator_id, dependent: :destroy
  has_many :events, foreign_key: :creator_id, dependent: :destroy
  has_many :trip_adminships, class_name: "TripAdministratoring", foreign_key: :user_id, dependent: :destroy
  has_many :administrated_trips, through: :trip_adminships, source: :trip
  has_many :trip_whitelistings, dependent: :destroy
  has_many :whitelisted_trips, through: :trip_whitelistings,
  		source: :trip

  [ :username, :email, :password, :password_confirmation ].each do |field| validates field, presence: true
  end
	validates :username, length: { maximum: 24,
					message: "Name lengths must be between 2-24 characters"  }
	validates :username, uniqueness: { case_sensitive: false }
	validates :password, length: { in: 6..16,
					message: "Password lengths must be between 6-16 characters"  }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	def administrates(trip)
		self.administrated_trips.include?(trip)
	end

	private
		def create_session_token
			self.session_token = SecureRandom.urlsafe_base64
		end


end
