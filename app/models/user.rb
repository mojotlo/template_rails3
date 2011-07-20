# == Schema Information
# Schema version: 20110606185931
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_one :profile, :dependent  => :destroy
    
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
                :length => {:maximum  => 50}
  validates :email, :presence  => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive  => false}#insufficient alone, requires on an index on email in the db to deal with quick changes
 validates :password,  :presence  => true,  
                       :confirmation  => true,
                       :length  => {:within  => 6..40}
 
 before_save :encrypt_password 
 
  def has_password?(submitted_password)
    encrypted_password==encrypt(submitted_password)
  end
  def self.authenticate(email, submitted_password)#used on sign-in
    user = find_by_email(email)
    return nil if user.nil? 
    return user if user.has_password?(submitted_password) #implicit: return nil if password mismatch
  end
  def self.authenticate_with_salt(id, cookie_salt)
    user=find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
                       
  private 
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) if new_record?
    end
    def encrypt (string)
      secure_hash("#{salt}--#{string}") 
    end
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
end
