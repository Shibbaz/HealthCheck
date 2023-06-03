class AddIndexesToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_index :notifications, :updated_at
    add_index :notifications, :receiver_id
  end
end
