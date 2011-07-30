class RemovePhotoFileNamePhotoContentTypePhotoFileSizeFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :photo_file_name
    remove_column :users, :photo_content_type
    remove_column :users, :photo_file_size
  end

  def self.down
    add_column :users, :photo_file_size, :integer
    add_column :users, :photo_content_type, :string
    add_column :users, :photo_file_name, :string
  end
end
