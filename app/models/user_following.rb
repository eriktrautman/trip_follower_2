class UserFollowing < ActiveRecord::Base
  attr_accessible :followed_id

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates_uniqueness_of :followed_id, scope: :follower_id

  belongs_to :following_user, class_name: "User", foreign_key: :follower_id
  belongs_to :followed_user, class_name: "User", foreign_key: :followed_id

end
