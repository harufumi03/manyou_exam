class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required, :logout_required
  
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    render template: "errors/error_404", status: 404, layout: 'application', layout: false
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    render template: "errors/error_500", status: 500, layout: 'application', layout: false
  end

  private

  def login_required
    redirect_to new_session_path, notice: 'ログインしてください' unless current_user
  end

  def logout_required
    redirect_to tasks_path, notice: 'ログアウトしてください' if current_user
  end
end
