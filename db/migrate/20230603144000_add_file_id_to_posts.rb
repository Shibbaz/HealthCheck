# frozen_string_literal: true

class AddFileIdToPosts < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :posts, :file_id, :uuid, default: 'gen_random_uuid()', null: false }
  end
end
