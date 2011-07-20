class CreateIndexForUserId < ActiveRecord::Migration
  def self.up
  end
  add_index :profiles, :user_id

  def self.down
  end
end
