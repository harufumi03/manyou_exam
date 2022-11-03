class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :logout_required
  before_action :correct_user, only: [:show, :edit]

  def index
    @tasks = current_user.tasks
    @tasks = @tasks.created.page(params[:page])  
    if params[:task].present?
      title = params[:task][:title]
      status = params[:task][:status]
      if title.present? && status.present?
        @tasks = Task.title_status(title, status).page(params[:page])
      elsif title.present?
        @tasks = Task.title(title).page(params[:page])
      elsif status.present?
        @tasks = Task.status(status).page(params[:page])
      end
    end
    if params[:sort_deadline_on]
      @tasks = Task.sort_deadline_on.page(params[:page]) 
    elsif params[:sort_priority]
      @tasks = Task.sort_priority.page(params[:page]) 
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path
      flash[:notice] = t('.created')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path
      flash[:notice] = t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
    flash[:notice] = t('.destroyed')
  end


  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def correct_user
    user_id = Task.find(params[:id]).user_id
    redirect_to tasks_path, notice: "アクセス権限がありません" unless current_user?(user_id)
  end
end

