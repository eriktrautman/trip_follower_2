class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username, unique: true
    	t.string :email, null: false, default: ""
      t.string :tagline
    	t.integer :profile_id
      t.boolean :site_admin, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
