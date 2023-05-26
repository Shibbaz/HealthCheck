class AddFollowersToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :followers, :uuid, array: true, default: [], null: false
  end
end
