class AddIndexesToUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_index :users, :email }
    safety_assured { add_index :users, :updated_at }
  end
end
