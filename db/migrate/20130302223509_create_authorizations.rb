class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer   :user_id
      t.string    :provider
      t.string    :uid
      t.string    :token
      t.string    :secret
    end

    add_index :authorizations, :user_id

  end


end
