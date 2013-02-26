class CreateUserFollowings < ActiveRecord::Migration
  def change
    create_table :user_followings do |t|
    	t.integer :follower_id
    	t.integer :followed_id

      t.timestamps
    end

    add_index :user_followings, :follower_id
    add_index :user_followings, :followed_id
    add_index :user_followings, [:follower_id, :followed_id], unique: true
  end
end
