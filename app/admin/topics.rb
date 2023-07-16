ActiveAdmin.register Topic do
    action_item :back_to_home, only: :index do
        link_to "Torna alla Home", root_path
      end
    permit_params :name

end