class AddGoogleDriveColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :google_drive_access_token, :string
    add_column :users, :google_drive_refresh_token, :string
    add_column :users, :google_drive_expires_at, :datetime
  end
end
