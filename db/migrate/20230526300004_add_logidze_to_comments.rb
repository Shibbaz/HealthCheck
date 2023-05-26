class AddLogidzeToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_comments, on: :comments
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_comments" on "comments";
        SQL
      end
    end
  end
end
