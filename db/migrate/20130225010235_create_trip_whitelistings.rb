class CreateTripWhitelistings < ActiveRecord::Migration
  def change
    create_table :trip_whitelistings do |t|
    	t.integer :user_id
    	t.integer :trip_id

      t.timestamps
    end

    add_index :trip_whitelistings, :user_id
    add_index :trip_whitelistings, :trip_id
    add_index :trip_whitelistings, [:user_id, :trip_id], unique: true
  end
end
