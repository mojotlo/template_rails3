class ProfilesController < ApplicationController
 before_filter :authenticate
 before_filter :has_profile?, :only  => [:new, :create]
 
 def show
   @user=current_user
   @profile=@user.profile
   @user.name
 end
 def new
   @user=current_user

    @title = "Create a profile"
    @profile = @user.create_profile(params[:profile])

 end
 def create
   @profile.save
    flash[:success] = "Check out your new profile"
    redirect_to @user
 end
 def edit
   @title="Edit Profile"
   @user=current_user
   @profile=current_user.profile
 end
 def index
   @title = "All users"
 end
 def update
   @title="Edit Profile"
   @user=current_user
    @profile=@user.profile
    if @profile.update_attributes(params[:profile])
      flash[:success]="Profile updated successfully."
      redirect_to @user
    else
      @title="Edit profile"
      render "edit"
    end
 end
end
