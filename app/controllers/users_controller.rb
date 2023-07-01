class UsersController < ApplicationController

    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:show]

    def show
        @user = User.find(params[:id])
    end
      
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          redirect_to @user, notice: 'Le informazioni dell\'utente sono state modificate.'
        else
          render :edit
        end
    end
    
    private

    def set_user
        @user = User.find(params[:id])
    end
    
    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
      
end

