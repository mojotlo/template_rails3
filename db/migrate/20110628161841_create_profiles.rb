class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.text :about
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.date :avatar_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
