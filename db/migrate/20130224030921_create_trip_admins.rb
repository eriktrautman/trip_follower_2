class CreateTripAdmins < ActiveRecord::Migration
  def change
    create_table :trip_admins do |t|
    	t.integer :user_id
    	t.integer :trip_id

      t.timestamps
    end

    add_index :trip_admins, :user_id
    add_index :trip_admins, :trip_id
    add_index :trip_admins, [:user_id, :trip_id], unique: true
  end
end
