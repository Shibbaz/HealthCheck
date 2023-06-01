class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.text :author_id
      t.text :receiver_id
      t.text :activity
      t.text :adapter
      t.text :destination_id

      t.timestamps
    end
  end
end
