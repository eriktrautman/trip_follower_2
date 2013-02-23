class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.string :name
    	t.date :date
    	t.string :hashtag
    	t.integer :creator_id
    	t.integer :trip_id
      t.string :tagline
      t.binary :picture
      t.integer :location_id

      t.timestamps
    end

    add_index :events, :hashtag
  end
end
