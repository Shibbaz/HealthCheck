# frozen_string_literal: true

class ChangeNotificationsIdsToUuids < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :author_uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_column :notifications, :user_uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_column :notifications, :destination_uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_column :notifications, :uuid, :uuid, default: 'gen_random_uuid()', null: false

    change_table :notifications do |t|
      t.remove :id

      t.remove :author_id
      t.remove :receiver_id
      t.remove :destination_id
      t.rename :author_uuid, :author_id
      t.rename :receiver_uuid, :receiver_id
      t.rename :destination_uuid, :destination_id
      t.rename :uuid, :id
    end
    execute 'ALTER TABLE notifications ADD PRIMARY KEY (id);'
  end
end
