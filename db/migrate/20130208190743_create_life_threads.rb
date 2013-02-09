class CreateLifeThreads < ActiveRecord::Migration
  def change
    create_table :life_threads do |t|
      t.integer :creator_id
      t.string :name
      t.string :tagline
      t.text :description
      t.string :hashtag
      t.date :s_date
      t.date :e_date

      t.timestamps
    end
  end
end
