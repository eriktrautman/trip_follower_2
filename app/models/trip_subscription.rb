class TripSubscription < ActiveRecord::Base
  attr_accessible :trip

  validates :trip, presence: true
  validates :subscriber, presence: true
  validates_uniqueness_of :trip_id, scope: :subscriber_id

  belongs_to :user, foreign_key: :subscriber_id
  belongs_to :trip

end
