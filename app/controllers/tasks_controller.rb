class TasksController < ApplicationController

  before_action :authenticate_user!

  before_action :set_task, only: [:update, :destroy]

  
  respond_to :json

  def index
    respond_to do |format|
      format.html 
      format.json { render json: current_user.tasks.with_sub_tasks.to_json(include: :sub_tasks ) }
     end
  end

  def create
    respond_with current_user.tasks.with_sub_tasks.create(task_params)
  end

  def update
    respond_with @task.update(task_params), location: '' 
  end

  def destroy
    respond_with @task.destroy!
  end

  private

  def set_task
    @task = current_user.tasks.with_sub_tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:body, :public, :completed, :sort_order, :sub_tasks ,sub_tasks_attributes: [:id, :body,  :_destroy])
  end
end
