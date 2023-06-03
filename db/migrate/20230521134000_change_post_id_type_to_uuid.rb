# frozen_string_literal: true

class ChangePostIdTypeToUuid < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :posts, :uuid, :uuid, default: 'gen_random_uuid()', null: false }

    safety_assured { 
      change_table :posts do |t|
        t.remove :id
        t.rename :uuid, :id
      end
    }
    safety_assured { execute 'ALTER TABLE posts ADD PRIMARY KEY (id);' }
  end
end
