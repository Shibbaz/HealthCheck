# frozen_string_literal: true

class AddPostIdToComments < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_reference :comments, :post, foreign_key: true, type: :uuid }
  end
end
