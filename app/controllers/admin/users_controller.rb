class Admin::UsersController < ApplicationController
  before_action :is_not_admin
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :logout_required
  before_action :only_one_destroy, only: [:destroy]
  before_action :only_one_update, only: [:update]
  
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
    @tasks = current_user.tasks
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザを削除しました' 
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def is_not_admin
    redirect_to tasks_path, notice: "管理者以外はアクセスできません" unless admin_user?
  end

  def only_one_destroy
    @user = User.find(params[:id])
    if User.where(admin: 'true').count == 1 && @user.admin == true
      redirect_to admin_users_path, notice: "管理者が0人になるため削除できません"
    end
  end

  def only_one_update
    @user = User.find(params[:id])
    if User.where(admin: 'true').count == 1 && @user.admin == true
      redirect_to admin_users_path, notice: "管理者が0人になるため権限を変更できません"
    end  
  end

end
