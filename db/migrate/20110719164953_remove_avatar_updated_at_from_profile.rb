class RemoveAvatarUpdatedAtFromProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :avatar_updated_at
  end

  def self.down
    add_column :profiles, :avatar_updated_at, :date
  end
end
