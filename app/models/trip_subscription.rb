class TripSubscription < ActiveRecord::Base
  attr_accessible :trip, :user

  validates :trip, presence: true
  validates :user, presence: true
  validates_uniqueness_of :trip_id, scope: :subscriber_id

  belongs_to :user, foreign_key: :subscriber_id
  belongs_to :trip

end
