class TripAdmin < ActiveRecord::Base
	attr_accessible :user, :trip

	belongs_to :user
	belongs_to :trip

	validates :user_id, presence: true
	validates :trip_id, presence: true
	validates_uniqueness_of :trip_id, scope: :user_id

end
