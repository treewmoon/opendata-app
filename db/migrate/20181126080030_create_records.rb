class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.references :user, foreign_key: true
      t.integer  :start_station_id,      null: false
      t.integer  :goal_station_id,       null: false
      t.string   :opponent,              null: false
      t.integer  :consumed_calory
      t.integer  :running_time
      t.integer   :result

      t.timestamps
    end
  end
end
