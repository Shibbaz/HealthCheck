# frozen_string_literal: true

class RenameInsightsToTextInPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :insights
    add_column :posts, :text, :text
  end
end
