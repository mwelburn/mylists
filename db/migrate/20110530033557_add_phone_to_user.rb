class AddPhoneToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :phone, :string

    add_index :users, :phone,                :unique => true
  end

  def self.down
    remove_column :users, :phone
  end
end
