class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.integer :creator_id
      t.string :name
      t.string :tagline
      t.text :description
      t.string :hashtag
      t.date :s_date
      t.date :e_date
      t.boolean :public_view, default: true
      t.boolean :whitelist_posters, default: false

      t.timestamps
    end

    add_index :trips, :hashtag
  end
end
