require 'spec_helper'

describe Profile do
  before(:each) do
    @user=Factory(:user)
  end
  it "should create a new instance given valid attributes" do
    @attr={:about=> 'value for content', :profile_avatar => File.new("#{Rails.root}/spec/fixtures/test_avatar.jpg")}
    @user.create_profile(@attr)
  end
  it "should reject non-image profile pictures as invalid" do
    #Profile.new {:profile_avatar => File.new(Rails.root + '/spec/fixtures/bad_avatar.pdf')}.should_not be_valid
  end 
  describe "user associations" do
    before(:each) do
      @attr={:about=> 'About me of the profile model spec'}
      @profile = @user.create_profile(@attr)
    end
    it "should have a user attribute" do
      @profile.should respond_to(:user)
    end
    it "should have the right associated user" do
      @profile.user_id.should == @user.id
      @profile.user.should == @user
    end
    it "should also destroy associated profile" do
      pid=@profile.id
      @user.destroy      
      Profile.find_by_id(pid).should be_nil
    end
  end
end
