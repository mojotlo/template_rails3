require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",           :with  => ""
          fill_in "Email",          :with  => ""
          fill_in "Password",       :with  => ""
          fill_in :user_password_confirmation,   :with  => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",           :with  => "Hootyhoo"
          fill_in "Email",          :with  => "Hootyhoo@Hootyhoo.com"
          fill_in "Password",       :with  => "Hootyhoo"
          fill_in :user_password_confirmation,   :with  => "Hootyhoo"
          click_button
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in "session_email", :with  => ""
        fill_in "session_password", :with  => ""
        click_button
        response.should have_selector("div.flash.error", :content  => "Invalid")
      end
    end
    describe "success" do
      it "should sign a user in" do 
        user=Factory(:user)
        visit signin_path
        fill_in "session_email", :with  => user.email
        fill_in "session_password", :with  => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end  
  end
  describe "settings/edit/update" do
    before(:each) do
      @new_email="newemail@example.com"
      @new_name="New Name"
      @bad_name=""
      @bad_email="impossible_email"
      @user=Factory(:user)
      visit signin_path
      fill_in "session_email", :with  => @user.email
      fill_in "session_password", :with  => @user.password
      click_button
    end
    describe "failure" do
      it "should not update the user and should have an error explanation" do
        visit edit_user_path(@user)
        fill_in "name", :with  => @bad_name
        fill_in "email", :with  => @bad_email
        click_button
        response.should have_selector("div#error_explanation")
        @user.reload
        @user.email.should_not == @bad_email
      end
    end
    describe "success" do
      it "should update the user and redirect to show" do 
        visit edit_user_path(@user)
        fill_in "name", :with  => @new_name
        fill_in "email", :with  => @new_email
        click_button
        response.should have_selector("div.flash.success", :content  => "updated")
        @user.reload
        @user.email.should == @new_email
      end
    end  
  end
  describe "change password" do
    before(:each) do
      @new_password="newpass"
      @bad_pass="short"
      @user=Factory(:user)
      @encrypted_pass=@user.encrypted_password
      visit signin_path
      fill_in "session_email", :with  => @user.email
      fill_in "session_password", :with  => @user.password
      click_button
    end
    describe "failure" do
      it "should change not change the encrypted password and should have an error" do
        visit change_password_page_path(@user)
        fill_in "password", :with  => @bad_pass
        fill_in "password_confirmation", :with  => @bad_pass
        click_button
        response.should have_selector("div#error_explanation")
        @user.encrypted_password.should == @encrypted_pass
      end
    end
    describe "success" do
      it "should update the user and redirect to show" do 
        visit change_password_page_path(@user)
        fill_in "password", :with  => @new_password
        fill_in "password_confirmation", :with  => @new_password
        click_button
        response.should have_selector("div.flash.success", :content  => "updated")
        @user.reload
        @user.encrypted_password.should_not == @encrypted_pass
      end
    end          
    describe "failure" do
      it "should change not change the encrypted password and should have an error" do
        visit change_password_page_path(@user)
        fill_in "password", :with  => @bad_pass
        fill_in "password_confirmation", :with  => @bad_pass
        click_button
        response.should have_selector("div#error_explanation")
        @user.encrypted_password.should == @encrypted_pass
      end
    end
    describe "success" do
      it "should update the user and redirect to show" do 
        visit change_password_page_path(@user)
        fill_in "password", :with  => @new_password
        fill_in "password_confirmation", :with  => @new_password
        click_button
        response.should have_selector("div.flash.success", :content  => "updated")
        @user.reload
        @user.encrypted_password.should_not == @encrypted_pass
      end
    end  
  end
  describe "forgot password" do
    before(:each) do
      @user=Factory(:user)

    end
    describe "success" do
      it "should redirect to reset password with a success notice" do
        visit forgot_password_path
        fill_in "email", :with  => @user.email
        click_button
        response.should have_selector("div.flash.success", :content  => "has been emailed")
        response.should have_selector("label", :content  => "Enter code")
      end
      it "should change the reset password code expiration time" do
        visit forgot_password_path
        fill_in "email", :with  => @user.email
        click_button
        @user.reload
        @user.reset_password_code_until.should < 2.days.from_now
        @user.reset_password_code_until.should > Time.now
      end
      it "should change the reset password code" do
        @old_code=@user.reset_password_code
        visit forgot_password_path
        fill_in "email", :with  => @user.email
        click_button
        @user.reload
        @new_code=@user.reset_password_code
        @old_code.should_not == @new_code
      end
    end
    describe "failure" do
      it "should redirect to the forgot password page with an error" do
        @unknown_email="impossibleemail"
        visit forgot_password_path
        fill_in "email", :with  => @unknown_email
        click_button
        response.should have_selector("div", :content => "not recognized")
        response.should have_selector("label", :content  => "email")
      end
    end
  end 
  describe "reset password" do
    before(:each) do
      @user=Factory(:user)
      visit forgot_password_path
      fill_in "email", :with  => @user.email
      click_button
      @user.reload
    end
    describe "success" do
      it "should redirect to change password with a form for changing the password" do
        @reset_code=@user.reset_password_code
        fill_in "reset_password_code", :with  => @reset_code
        click_button
        controller.should be_signed_in
        response.should have_selector("label", :content  => "Password")        
      end
    end
    describe "failure" do
      it "should render to the reset password page with an error if the code is wrong" do
        @reset_code="nonsense"
        fill_in "reset_password_code", :with  => @reset_code
        click_button
        response.should have_selector("label", :for  => "reset_password_code")
        response.should have_selector("div", :content  => "invalid")
      end
      it "should render to the reset password page with an error if the code is expired" do
        @reset_code=@user.reset_password_code
        @user.update_attributes(:reset_password_code_until  => 1.day.ago)
        fill_in "reset_password_code", :with  => @reset_code
        click_button
        response.should have_selector("label", :for  => "email_find")
        response.should have_selector("div", :content  => "expired")
      end
    end
  end   
end
