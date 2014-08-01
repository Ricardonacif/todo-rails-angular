class SubTasksController < ApplicationController
  before_action :set_sub_task, only: [:update, :destroy]

  before_action :authenticate_user!
  respond_to :json

  def create

    task = current_user.tasks.find(params[:sub_task][:task_id])
    if task.present?
      sub_task = task.sub_tasks.create(sub_task_params)
      respond_with sub_task, location: [task, sub_task]
    end
  end

  def update
    respond_with @sub_task.update(sub_task_params), location: [@sub_task.task , @sub_task]
  end

  def destroy
    respond_with @sub_task.destroy!
  end

  private

  def set_sub_task
    @sub_task = current_user.sub_tasks.find(params[:id])
  end

  def sub_task_params
    params.require(:sub_task).permit(:task_id, :public, :completed, :body)
  end
end