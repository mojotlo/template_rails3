require 'spec_helper'
describe "Profiles" do
  describe "new" do
    describe "success" do
      it "should make a new profile" do
        @user=Factory(:user)
        visit signin_path
        fill_in "session_email", :with  => @user.email
        fill_in "session_password", :with  => @user.password
        click_button
        lambda do
          visit new_user_profile_path(@user)
          fill_in "profile_about", :with  => "hootyhoo"
          click_button       
          response.should render_template('users/show')
        end.should change(Profile, :count).by(1)
      end
    end
  end
end
