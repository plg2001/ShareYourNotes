class ChangeColumnTypeInTags < ActiveRecord::Migration[6.1]
  def change
    change_column :tags, :body, :string
  end
end
