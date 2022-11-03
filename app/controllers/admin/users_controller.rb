class Admin::UsersController < ApplicationController
  before_action :is_not_admin
  skip_before_action :logout_required
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
      flash[:notice] = 'ユーザを登録しました'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
      flash[:notice] = 'ユーザを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
    flash[:notice] = 'ユーザを削除しました'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def is_not_admin
    redirect_to tasks_path, notice: "管理者以外はアクセスできません" unless admin_user?
  end

end
