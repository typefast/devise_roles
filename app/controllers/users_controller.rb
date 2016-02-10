class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
    
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User Updated"
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
  
  def destroy
    user = User.find(params[:id])
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end
  
  private
    
    def secure_params
      params.require(:user).permit(:role)
    end

end
