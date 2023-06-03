class AddIndexesToNotifications < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_index :notifications, :updated_at }
    safety_assured { add_index :notifications, :receiver_id }
  end
end
