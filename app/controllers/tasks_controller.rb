class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  
  def index
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:notice] = 'タスクを追加しました。'
      redirect_to root_url
    else
      flash.now[:notice] = "タスクが追加できませんでした"
      render :new
    end
  end

  def edit
  end

  def update
    
    if @task.update(task_params)
      flash[:success] = "タスクを編集しました"
      redirect_to @task
    else
      flash[:danger] = "タスクが編集できませんでした"
      render :new
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = "タスクを削除しました"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
    
    unless @task
      redirect_to root_url
    end
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
