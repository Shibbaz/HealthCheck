# frozen_string_literal: true

class ChangeUserIdTypeToUuid < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_column :users, :uuid, :uuid, default: 'gen_random_uuid()', null: false }

    safety_assured { change_table :users do |t|
      t.remove :id
      t.rename :uuid, :id
    end }
    safety_assured { execute 'ALTER TABLE users ADD PRIMARY KEY (id);' }
  end
end
