# frozen_string_literal: true

class RenameInsightsToTextInPosts < ActiveRecord::Migration[7.0]
  rename_column :posts, :insights, :text
end
