class AddColumnToTableUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :rating, :integer,default: 0,null: false
  end
end
