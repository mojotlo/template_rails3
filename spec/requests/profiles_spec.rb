require 'spec_helper'
describe "Profiles" do
  describe "new" do
    describe "success" do
      before(:each) do
        @user=Factory(:user)
        visit signin_path
        fill_in "session_email", :with  => @user.email
        fill_in "session_password", :with  => @user.password
        click_button
      end
      it "should make a new profile and render user show page" do
        lambda do
          visit new_user_profile_path(@user)

          fill_in "profile_about", :with  => "hootyhoo"
          click_button       
          response.should render_template('users/show')
        end.should change(Profile, :count).by(1)
      end
      describe "Paperclip photos" do
        describe "success" do
          before(:each) do
            visit new_user_profile_path(@user)
            fill_in "profile_avatar", :with  => Rails.root + 'spec/fixtures/test_avatar.jpg'
            click_button
            @user.reload
            @profile=@user.profile
          end
          it "should have the right file name" do
            @profile.avatar_file_name.should == "test_avatar.jpg"
          end
          it "should have the right file size" do
            @profile.avatar_file_size.should == 12966
          end          
        end
        describe "failure" do
          before (:each) do
            visit new_user_profile_path(@user)
            attach_file 'profile_avatar', "#{Rails.root}/spec/fixtures/bad_avatar.pdf", 'application/pdf'
            click_button
          end
          it "should re-render profile edit" do
            response.should have_selector("label", :content  => "Profile Picture")
          end
          it "should reject non images" do
            visit user_path(@user)
            @user.reload
            @profile=@user.profile
            @profile.avatar_file_name.should be_nil
            response.should have_selector("img", :alt  => "Missing_medium")
          end
        end
      end
    end
  end
end
