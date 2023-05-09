class CreateUser < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer 'id_n' 
      t.string 'user_name' 
      t.string 'e_mail' 
      t.datetime 'birth_date' 
      t.string 'password_hash'
      t.timestamps
    end
  end
end
