class TripWhitelisting < ActiveRecord::Base
  attr_accessible :trip, :user

  validates :trip, presence: true
  validates :user, presence: true
  validates_uniqueness_of :user_id, scope: :trip_id

  belongs_to :trip
  belongs_to :user

end
