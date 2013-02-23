class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation,
  		:alias

  has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :create_session_token

  has_many :trips, foreign_key: :creator_id
  has_many :events, foreign_key: :creator_id

  [ :username, :email, :password, :password_confirmation ].each do |field| validates field, presence: true
  end
	validates :username, length: { maximum: 24,
					message: "Name lengths must be between 2-24 characters"  }
	validates :password, length: { in: 6..16,
					message: "Password lengths must be between 6-16 characters"  }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

	private
		def create_session_token
			self.session_token = SecureRandom.urlsafe_base64
		end


end
