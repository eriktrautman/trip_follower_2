class CreateTripAdministratorings < ActiveRecord::Migration
  def change
    create_table :trip_administratorings do |t|
    	t.integer :user_id
    	t.integer :trip_id

      t.timestamps
    end

    add_index :trip_administratorings, :user_id
    add_index :trip_administratorings, :trip_id
    add_index :trip_administratorings, [:user_id, :trip_id], unique: true
  end
end
