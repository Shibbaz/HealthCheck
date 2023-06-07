# frozen_string_literal: true

class AddVisibilityToPosts < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :posts, :visibility, :boolean, default: false, null: false }
  end
end
