class CreatePosts < ActiveRecord::Migration[6.1]
    def change
      create_table :posts do |t|
        t.uuid :user_id
        t.text :insights
        t.string :question, default: "How do you feel today?"
        t.integer :feeling, default: 0
        t.uuid :likes, array: true, default: []
        t.timestamps
      end
    end
  end