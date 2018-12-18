class CreateDistances < ActiveRecord::Migration[5.0]
  def change
    create_table :distances do |t|
      t.integer :s_id
      t.integer :g_id
      t.integer :meter

      t.timestamps
    end
  end
end
