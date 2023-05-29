# frozen_string_literal: true

class AddUserIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :user, foreign_key: true, type: :uuid
  end
end
