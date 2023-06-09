# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    safety_assured {
      create_table :posts do |t|
        t.uuid :user_id
        t.text :insights
        t.string :question, default: 'How do you feel today?'
        t.integer :feeling, default: 0
        t.uuid :likes, array: true, default: []
        t.timestamps
      end
    }
  end
end
