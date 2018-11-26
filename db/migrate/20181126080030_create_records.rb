class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.references :user, foreign_key: true
      t.integer  :start_station_id,             null: false
      t.integer  :goal_station_id,              null: false
      t.integer  :calory
      t.integer  :time

      t.timestamps
    end
  end
end
