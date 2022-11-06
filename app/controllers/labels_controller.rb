class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]
  skip_before_action :login_required, only: [:new, :create]
  skip_before_action :logout_required


  def index
    @labels = @current_user.labels
  end

  def new
    @label = Label.new(label_params)
    @label.user_id = current_user.id
    if @label.save
      redirect_to labels_path, notice: 'ラベルを登録しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: 'ラベルを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_path, notice: 'ラベルを削除しました'
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
