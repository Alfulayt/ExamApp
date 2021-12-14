class AddcolumnforUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :refresh_token, :text
  end
end
