# frozen_string_literal: true

class AddStripeKeyToUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :users, :stripe_key, :text, default: "", null: false }
  end
end
