require 'spec_helper'

describe UsersController do
  render_views

  describe "Get 'show'" do
    before(:each) do
      @user=Factory(:user)
    end
    it "should be successful" do
      get  :show, :id => @user
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
   it "should have a profile pic" do
     get :show, :id  =>  @user
     response.should have_selector("img", :class  => "profile_pic")
   end
    it "should include the user's name" do
      get :show, :id  => @user
      response.should have_selector("h1", :content  => @user.name)
    end
    describe "for signed in users" do
      it "should allow one user to look at anothers profile" do
        test_sign_in(@user)
        @user2=Factory(:user, :email  => "example4000@example.com")
        get :show, :id  => @user2
        response.should be_success
      end
      it "should allow a user to view their own profile" do
        test_sign_in(@user)
        get :show, :id  => @user
        response.should be_success
      end
    end
  end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have the right title" do
      get 'new'
      response.should have_selector('title', :content  => "Sign up")
    end
  end
  describe "POST :create" do
    describe "failure" do
      before (:each) do
        @attr = {:name  => "", :email  => "",
        :password  => "", :password_confirmation  => ""}
      end
      it 'should not create a user' do
        lambda do
          post :create, :user  => @attr
        end.should_not change(User, :count)
      end
      it "should have the right title" do
        post :create, :user  => @attr
        response.should have_selector("title", :content  => "Sign up")
      end
      it "should render the :new page" do
        post :create, :user  => @attr 
        response.should render_template('new')
      end
    end
    describe "success" do
      before (:each) do
        @attr = {:name  => "Joe", :email  => "Joe@gmi.com",
        :password  => "Joe@gmi.com", :password_confirmation  => "Joe@gmi.com"}
      end
      it "should create a user" do
        lambda do
          post :create, :user  => @attr
        end.should change(User, :count).by(1)
      end
      it "should redirect to the :user show page" do
        post :create, :user  => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message" do
        post :create, :user  => @attr
        flash[:success].should =~ /welcome to the rails template/i
      end
      it "should sign the user in" do
        post :create, :user  => @attr
        controller.should be_signed_in
      end
    end
  end
  describe "GET 'edit" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    it "should be successful" do
      get 'edit', :id  => @user
      response.should be_success
    end
    it "should have the right title" do
      get :edit, :id  => @user
      response.should have_selector('title',
                                    :content  => 'Edit')
    end
  end
  describe "POST 'update'" do
    before(:each) do
      @user=Factory(:user)
      test_sign_in(@user)
    end
    describe "failure" do
      before(:each) do
        @attr = {:name  => "", :email  => "", :password  => "", :password_confirmation => ""}
      end
      it "should render the edit page" do
        get :edit, :id  => @user
        put :update, :id => @user, :user  => @attr 
        response.should render_template('edit')
      end
      it "should have the right title" do
        get :edit, :id  => @user
        put :update, :id => @user, :user  => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end
    describe "success" do
      before(:each) do
        @attr = {:name  => "Michael Hartl", :email => "newemail@email.com", :password =>"newpass1", :password_confirmation  => "newpass1"}
      end
      it "should update the user attributes" do
        put :update, :id  => @user, :user  => @attr
        @user.reload
        @user.email.should==@attr[:email]
        @user.name.should==@attr[:name]
      end
      it "should redirect to the user/show page" do
        put :update, :id  => @user, :user  => @attr
        response.should redirect_to(user_path(@user))
      end
      it "should have a flash message" do
        put :update, :id  => @user, :user  => @attr
        flash[:success].should =~/updated/i
      end
    end
  end  
  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end
    describe "for non-signed in users" do  
      it "should deny access to 'edit" do
        get :edit, :id  => @user
        response.should redirect_to(signin_path)
      end
      it "should deny access to 'update" do
        put :update, :id  => @user, :user  => {}
        response.should redirect_to(signin_path)
      end
    end
    describe "for signed-in users" do
      before(:each) do
        wrong_user=Factory(:user, :email  => "user@example.net")
        test_sign_in(wrong_user)
      end
      it "should require matching users for edit" do
        get :edit, :id  => @user
        response.should redirect_to(root_path)
      end
      it "should require matching users for update" do
        put :update, :id  => @user, :user  => {}
        response.should redirect_to(root_path)
      end
    end
  end 
  describe "GET 'index'" do
    describe "for non-signed in users" do
      it "should deny access" do
        get 'index'
        response.should redirect_to(signin_path)
        flash[:notice].should=~/signed in/i
      end
    end
    describe "for signed in users" do
      before(:each) do
        @user=test_sign_in(Factory(:user))
        second=Factory(:user, :email  => "secondemail@email.com")
        third=Factory(:user, :email  => "third@email.com")
        @users=[@user, second, third]      
      end
      it "should be successful" do
        get :index
        response.should be_success
      end
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end 
      it "should have a photo for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("img")
        end
      end 
    end  
  end
end

    

