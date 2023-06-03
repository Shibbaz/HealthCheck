class AddIndexesToPosts < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_index :posts, :user_id }
  end
end
