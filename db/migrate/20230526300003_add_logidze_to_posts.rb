# frozen_string_literal: true

class AddLogidzeToPosts < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :posts, :log_data, :jsonb }

    reversible do |dir|
      safety_assured {
        dir.up do
          create_trigger :logidze_on_posts, on: :posts
        end

        dir.down do
          execute <<~SQL
            DROP TRIGGER IF EXISTS "logidze_on_posts" on "posts";
          SQL
        end
      }
    end
  end
end
