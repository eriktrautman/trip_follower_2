class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # REV: tabs
    	t.string :username, unique: true
    	t.string :email
      t.string :tagline
    	t.string :password_digest
    	t.integer :profile_id
      t.string :session_token, null: false
      t.boolean :site_admin, default: false

      t.timestamps
    end

    add_index :users, :session_token, unique: true
    add_index :users, :email, unique: true
  end
end
