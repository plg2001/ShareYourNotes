class AddColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :profile_img_url, :string
  end
end
