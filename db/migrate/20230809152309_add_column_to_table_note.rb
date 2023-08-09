class AddColumnToTableNote < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :format, :string
  end
end
