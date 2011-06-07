require 'spec_helper'

describe User do
  before(:each) do
    @attr={:name => "Example User", :email  => "Example@example.com"}
  end
  it "should create a new instance of a user" do
    User.create!(@attr)
  end
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name="a"*51
    long_name_user=User.new(@attr.merge(:name => long_name ))
    long_name_user.should_not be_valid
  end
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  it "should accept valid email addresses" do
    valid_emails=%w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    valid_emails.each do |email|
      valid_email_user=User.new(@attr.merge(:email=>email))
      valid_email_user.should be_valid
    end
  end
  it "should reject invalid email addresses" do
    invalid_emails=%w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_emails.each do |email|
      invalid_email_user=User.new(@attr.merge(:email => email))
      invalid_email_user.should_not be_valid
    end
  end
  it "should reject duplicate emails" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  it "should reject emails identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
end
