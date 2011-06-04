class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.integer :user_id
      t.string :category
      t.string :content
      t.date :created_at
      t.date :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
