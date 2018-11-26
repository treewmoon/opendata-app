class AddHeightToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :height, :Integer,null: false
  end
end
