class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @search = User.search(params[:q])
    @users = @search.result.paginate(page: params[:page])
  end

  def show
  	set_user
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    
	  if @user.save
      sign_in @user
	  	flash[:success] = "Welcome to Harding CS Connect!"
	  	redirect_to @user
	  else
	    render 'new'
	  end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile was successfully updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    set_user 
    @user.destroy
    flash[:success] = "User was successfully deleted"
    redirect_to users_url 
  end

  def map
    @users = User.all
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      marker.infowindow render_to_string(:partial => "/users/map_template", :locals => { :user => user})
    end
  end

  private

    def signed_in_user
      unless signed_in?
        flash[:warning] = "Please sign in"
        save_location
        redirect_to signin_url
      end
    end

    def correct_user
      set_user
      redirect_to(root_url) unless current_user?(@user)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :city, :state, :job_title, :company_or_organization, :password, 
      														 :password_confirmation)
    end
end
