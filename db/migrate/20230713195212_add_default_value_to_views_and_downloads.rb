class AddDefaultValueToViewsAndDownloads < ActiveRecord::Migration[6.1]
  def up
    change_column :notes, :views, :integer, default: 0
    change_column :notes, :downloads, :integer, default: 0
  end
  
  def down
    change_column :notes, :views, :integer, default: nil
    change_column :notes, :downloads, :integer, default: nil
  end
end
