class AddFirstLoginToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :first_login, :boolean, default: true
  end
end
