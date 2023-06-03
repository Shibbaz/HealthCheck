# frozen_string_literal: true

class AddFollowersToUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :users, :followers, :uuid, array: true, default: [], null: false }
  end
end
