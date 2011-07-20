class UsersController < ApplicationController
  before_filter :authenticate, :only  => [:edit, :update, :index]
  before_filter :correct_user, :only  => [:edit, :update]
  def show
    @user=User.find(params[:id])
    @title=@user.name
    @profile=@user.profile
  end

  def new
    @title = "Sign up"
    @user = User.new
  end    
  def create
    @user=User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to the Rails Template!"
      redirect_to @user
    else 
      @title = "Sign up"
      render 'new'
    end
  end
  
  
  def edit
    @user=User.find(params[:id])
    @title="Edit Settings"
  end
  def update
    @user=User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success]="Profile updated successfully."
      redirect_to @user
    else
      @title="Edit user"
      render "edit"
    end
  end

  def index
    @title="All users"
    @users=User.paginate(:page  => params[:page])
  end
  private
    def correct_user
      @user=User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
