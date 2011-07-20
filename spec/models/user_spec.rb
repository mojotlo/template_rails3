require 'spec_helper'

describe User do
  before(:each) do
    @attr={:name => "Example User", 
      :email  => "Example@example.com",
      :password => "foobar", 
      :password_confirmation  => "foobar",}
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
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password  =>  "")).should_not be_valid
    end
    it "should require a valid password confirmation" do
      User.new(@attr.merge(:password_confirmation=> "invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      User.new(@attr.merge(:password => "w" * 5)).should_not be_valid
    end
    it "should reject long passwords" do
      User.new(@attr.merge(:password => "w" * 41)).should_not be_valid
    end
  end
  describe "password encryption" do
    before(:each) do
      @user=User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should have something as an encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    describe "has password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
      describe "authenticate method" do
        it "should return nil for an email/password mismatch" do
          wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
          wrong_password_user.should be_nil
        end
        it "should return nil if email has no associated user" do
          wrong_email_user = User.authenticate("crazyemail@hootenanny.com", @attr[:password])
          wrong_email_user.should be_nil
        end
        it "should return user for correct email password combo" do
          matching_user=User.authenticate(@attr[:email], @attr[:password])
          matching_user.should==@user
        end
      end
    end
    describe "profile responses" do
      before(:each) do
        @user=User.create(@attr)
      end
      it "should respond to profile attribute" do
        @user.should respond_to(:profile)
      end
    end
  end
    
end
