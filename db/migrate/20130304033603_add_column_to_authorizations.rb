class AddColumnToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :account_name, :string
  end
end
