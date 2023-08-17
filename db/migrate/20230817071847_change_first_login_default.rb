class ChangeFirstLoginDefault < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :first_login, :boolean, default: false
  end

  def down
    change_column :users, :first_login, :boolean, default: true
  end
end
