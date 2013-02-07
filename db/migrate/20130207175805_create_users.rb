class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :fname
    	t.string :lname
    	t.string :alias
    	t.string :email
    	t.string :password_digest
    	t.integer :profile_id

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
