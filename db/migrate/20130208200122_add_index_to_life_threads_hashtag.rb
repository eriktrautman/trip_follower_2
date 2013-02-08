class AddIndexToLifeThreadsHashtag < ActiveRecord::Migration
  def change
    add_index :life_threads, :hashtag
  end
end