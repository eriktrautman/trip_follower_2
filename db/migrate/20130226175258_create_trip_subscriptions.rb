class CreateTripSubscriptions < ActiveRecord::Migration
  def change
    create_table :trip_subscriptions do |t|
      t.integer :subscriber_id
      t.integer :trip_id

      t.timestamps
    end

    add_index :trip_subscriptions, :subscriber_id
    add_index :trip_subscriptions, :trip_id
    add_index :trip_subscriptions, [:subscriber_id, :trip_id], unique: true
  end
end
