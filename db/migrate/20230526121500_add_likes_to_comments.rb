# frozen_string_literal: true

class AddLikesToComments < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :comments, :likes, :uuid, array: true, default: [], null: false }
  end
end
