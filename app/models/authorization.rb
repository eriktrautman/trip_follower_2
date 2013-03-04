class Authorization < ActiveRecord::Base
  attr_accessible :uid, :provider, :token, :secret, :account_name

  validates :uid, presence: true
  validates :provider, presence: true
  validates :user, presence: true
  validates :token, presence: true

  validates_uniqueness_of :user_id, scope: :provider

  belongs_to :user

end