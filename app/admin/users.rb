ActiveAdmin.register User do
  action_item :back_to_home, only: :index do
    link_to "Torna alla Home", root_path
  end
  
  permit_params :email, :admin,:username
  
  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :email
      f.input :admin
    end
    f.actions
  end
  index do
    id_column
    column :username
    column :name
    column :email
    column :admin
    column :provider
    actions
  end
end
