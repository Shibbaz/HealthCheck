class AddIndexesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email
    add_index :users, :updated_at
  end
end
