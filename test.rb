require 'google_drive'

# Create a GoogleDrive::Session object

# Authorize the user
session = GoogleDrive::Session.from_config("config1.json")

# Get a list of all the files in the user's Google Drive
files = session.files

# Iterate over the files and print their names
files.each do |file|
  puts file.name
end