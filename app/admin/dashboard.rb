# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do    
    panel "Utenti registrati" do
      table_for User.all do
        column :email
        column :encrypted_password
        column :created_at
      end
    end

    panel "Tags" do
      table_for Tag.all do
        column :body
        column :created_at
      end
    end
    
  end 
end
