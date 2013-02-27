class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username, unique: true
    	t.string :email, null: false, default: ""
      t.string :tagline
    	# XDevise t.string :password_digest
    	t.integer :profile_id
      # XDevise t.string :session_token, null: false
      t.boolean :site_admin, default: false

      t.timestamps
    end

    # XDevise add_index :users, :session_token, unique: true
    add_index :users, :email, unique: true
  end
end
