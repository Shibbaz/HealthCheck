# frozen_string_literal: true

class ChangeCommentIdTypeToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :uuid, :uuid, default: 'gen_random_uuid()', null: false

    change_table :comments do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute 'ALTER TABLE comments ADD PRIMARY KEY (id);'
  end
end
