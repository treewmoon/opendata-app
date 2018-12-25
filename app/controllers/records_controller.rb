require "jre_api.rb"

class RecordsController < ApplicationController
  #スタート選択
  def new
    @title = "Select Start"
  end

  def create
    record = Record.create(\
      start_station_id:  record_create_params[:start_station_id],\
      user_id:           current_user.id)
    # new_nextアクションへ
    redirect_to "/records/#{record.id}/new_next"
  end

  #ゴール設定
  def new_next
    @record = Record.find(params[:id])
    @title = "Select Goal"
  end

  def set_goal
    record = Record.find(params[:id])
    record.update(\
      goal_station_id: record_set_goal_params[:goal_station_id],\
      direction:       record_set_goal_params[:direction])
    # new_lastアクションへ
    redirect_to "/records/#{record.id}/new_last"
  end

  #相手設定
  def new_last
    @record = Record.find(params[:id])
    @title = "Select train"
  end

  def set_opponent
    record = Record.find(params[:id])
    record.update(opponent:record_set_opponent_params[:opponent])
    # Editアクションへ
    redirect_to "/records/#{record.id}/edit"
  end

  def edit
    @record = Record.find(params[:id])
    @title = "Running"
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
    @title = "Result"
  end

  private
    def record_set_goal_params
      params.permit(:goal_station_id,:direction)
    end
    def record_set_opponent_params
      params.permit(:opponent)
    end
    def record_create_params
      params.permit(:start_station_id)
    end
    def record_update_params
      params.permit(:consumed_calory,:running_time,:result)
    end
end
