class AddNullConstraintToUsersSessionToken < ActiveRecord::Migration
  def change
  	change_column :users, :session_token, :string, null: false
  end
end
