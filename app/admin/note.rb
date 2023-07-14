ActiveAdmin.register Note do
    permit_params :name, :user

    form do |f|
        f.semantic_errors
        f.inputs do
          f.input :name
          f.input :user
        end
        f.actions
      end
      index do
        id_column
        column :name
        column :user
        actions
      end
end