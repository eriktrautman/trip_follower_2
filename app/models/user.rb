class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :email, :password, :password_confirmation,
  		:alias

  has_secure_password

  [ :fname, :email, :password, :password_confirmation ].each do |field| validates field, presence: true
  end

	[ :fname, :lname ].each do |field| 
		validates field, length: { in: 2..24,
					message: "Name lengths must be between 2-24 characters"  }
	end

	validates :password, length: { in: 6..16,
					message: "Password lengths must be between 6-16 characters"  }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

end