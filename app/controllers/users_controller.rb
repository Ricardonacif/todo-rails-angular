class UsersController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @users = User.includes(:tasks).includes(tasks: :sub_tasks).all
  end

  def show
    @user = User.with_public_tasks.where(id: params[:id]).first
    redirect_to users_path, notice: "Sorry, this user doesn't have public tasks" unless @user.present?
  end
end