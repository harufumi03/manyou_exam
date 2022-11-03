class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :logout_required, except: [:new, :create]
  before_action :correct_user, only: [:show, :edit]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to tasks_path, notice: 'アカウントを登録しました'
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
      redirect_to user_path(current_user.id), notice: 'アカウントを更新しました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    user_id = User.find(params[:id]).id
    redirect_to tasks_path, notice: 'アクセス権限がありません' unless current_user?(user_id)
  end
end

