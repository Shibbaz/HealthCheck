class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :archive
      t.boolean :is_admin
      t.integer :phone_number
      t.integer :gender
      t.timestamps
    end
  end
end
