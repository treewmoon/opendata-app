class AddChangeToRecords < ActiveRecord::Migration[5.0]
  def change
     change_column_null :records, :start_station_id, true
     change_column_null :records, :goal_station_id, true
     change_column_null :records, :opponent, true
  end
end
