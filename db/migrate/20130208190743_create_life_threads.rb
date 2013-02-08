class CreateLifeThreads < ActiveRecord::Migration
  def change
    create_table :life_threads do |t|

      t.timestamps
    end
  end
end
