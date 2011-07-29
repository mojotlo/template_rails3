class AddResetPasswordCodeAndResetPasswordCodeUntilToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_password_code, :string
    add_column :users, :reset_password_code_until, :datetime
  end

  def self.down
    remove_column :users, :reset_password_code_until
    remove_column :users, :reset_password_code
  end
end
