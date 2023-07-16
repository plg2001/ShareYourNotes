ActiveAdmin.register RichiestaAdmin do
  action_item :back_to_home, only: :index do
    link_to "Torna alla Home", root_path
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :content
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :content]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  

end
