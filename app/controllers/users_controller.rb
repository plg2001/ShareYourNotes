class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy,:index]
  before_action :authenticate_user!, except: [:show]

  def index
    @users = User.all # o qualsiasi altra query per ottenere gli utenti desiderati
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  
  def search
    @search_query = params[:search]
    @search_result = User.where('username LIKE ? OR id = ?', "%#{@search_query}%", @search_query)
  
    respond_to do |format|
      format.html
      format.json { render json: @search_result }
    end
  end

  def update
    if user_params[:password].present?
      if @user.valid_password?(user_params[:current_password])
        if @user.update(user_params.except(:current_password))
          bypass_sign_in(@user)
          redirect_to user_path(@user), notice: 'Le informazioni sono state modificate.'
        else
          flash.now[:alert] = 'Si è verificato un errore durante la modifica delle informazioni.'
          render :edit
        end
      else
        flash.now[:alert] = 'La password precedente non è corretta.'
        render :edit
      end
    else
      if @user.update(name: user_params[:name], username: user_params[:username])
        bypass_sign_in(@user)
        redirect_to user_path(@user), notice: 'Le informazioni sono state modificate.'
      else
        flash.now[:alert] = 'Si è verificato un errore durante la modifica delle informazioni.'
        render :edit
      end
    end
  end

  def destroy
    begin
      prova(@user)
      createrating = CreateRating.where(user_id: @user.id)
      createrating.delete_all
      @user.destroy
      redirect_to root_path, notice: 'Account eliminato con successo.'
    rescue => e
      flash[:alert] = "Si è verificato un errore durante l'eliminazione dell'account: #{e.message}"
      redirect_to user_path(@user)
    end
  end

  def prova(user)
    notes = Note.where(user_id: user.id)
    notes.each do |note|
      google_drive_link= note.google_drive_link
      delete_G_Drive(google_drive_link)
    end
  end

  def delete_G_Drive(google_drive_link)
    session = GoogleDrive::Session.from_config("config.json")
    file_id = google_drive_link.match(/\/file\/d\/(.+?)\//)[1]
    file = session.file_by_id(file_id)
    file.delete
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :name, :email, :current_password, :password, :password_confirmation)
  end
end



