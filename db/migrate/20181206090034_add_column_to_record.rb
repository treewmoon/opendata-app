class AddColumnToRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :direction, :integer
  end
end
