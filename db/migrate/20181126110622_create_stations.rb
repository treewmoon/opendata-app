class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.string  :name_ja,               null: false, unique: true
      t.string  :name_en,               null: false, unique: true
    end
  end
end
