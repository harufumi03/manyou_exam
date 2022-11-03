class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required, :logout_required

  private

  def login_required
    redirect_to new_session_path unless current_user
    flash[:notice] = 'ログインしてください'
  end

  def logout_required
    redirect_to tasks_path if current_user
    flash[:notice] = 'ログアウトしてください'
  end
end
