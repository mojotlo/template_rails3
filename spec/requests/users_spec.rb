require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_index_path
      response.status.should be(200)
    end
  end
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",           :with  => ""
          fill_in "Email",          :with  => ""
          fill_in "Password",       :with  => ""
          fill_in "Confirmation",   :with  => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
  end
end
