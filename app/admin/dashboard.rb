# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

   action_item :back_to_home, only: :index do
    link_to "Torna alla Home", root_path
  end
  
  content title: proc { I18n.t("active_admin.dashboard") } do    
   

    panel "Tags" do
      table_for Tag.all do
        column :name
        column :created_at
      end
    end
    panel "Topic" do
      table_for Topic.all do
        column :name
        column :created_at
      end
    end
    
    panel "Faculty" do
      table_for Faculty.all do
        column :name
        column :created_at
      end
    end
    
    

  end 
end
