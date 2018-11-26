class RecordsController < ApplicationController
  def new
  end

  def create
    record = Record.create(\
      start_station_id:  record_create_params[:start_station_id],\
      goal_station_id:   record_create_params[:goal_station_id],\
      opponent:          record_create_params[:opponent],\
      user_id:           current_user.id)
    # Editアクションへ
    redirect_to "/records/#{record.id}/edit"
  end

  def edit
    @record = Record.find(params[:id])
  end

  def update
    record = Record.find(params[:id])
    record.update(\
      consumed_calory:  record_update_params[:consumed_calory],\
      running_time:     record_update_params[:running_time],\
      result:           record_update_params[:result])
    # Showアクションへ
    redirect_to "/records/#{record.id}"
  end

  def show
    @record = Record.find(params[:id])
  end

  private
    def record_create_params
      params.permit(:start_station_id, :goal_station_id, :opponent)
    end
    def record_update_params
      params.permit(:consumed_calory,:running_time,:result)
    end
end
