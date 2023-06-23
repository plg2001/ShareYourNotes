class RenameColumnInTags < ActiveRecord::Migration[6.1]
  def change
    rename_column :tags, :body, :name
  end
end
