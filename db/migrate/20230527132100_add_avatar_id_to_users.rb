# frozen_string_literal: true

class AddAvatarIdToUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :users, :avatar_id, :uuid, default: 'gen_random_uuid()', null: false }
  end
end
