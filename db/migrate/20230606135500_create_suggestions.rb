class CreateSuggestions < ActiveRecord::Migration[7.0]
  def change
    safety_assured {
      create_table :suggestions do |t|
        t.text :author_id
        t.text :receiver_id
        t.timestamps
      end
    }
  end
end
