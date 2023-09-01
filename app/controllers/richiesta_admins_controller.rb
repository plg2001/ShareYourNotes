class RichiestaAdminsController < ApplicationController
  before_action :set_richiesta_admin, only: %i[ show edit update destroy ]


  def index
    @richiesta_admins = RichiestaAdmin.all
  end

  def show
  end


  def new
    @richiesta_admin = RichiestaAdmin.new
  end
 
  def create_richiesta_admin
    @richiesta_admin = current_user.richiesta_admins.new(user_id: current_user.id, content: 'Salve desidero diventare un amministratore del vostro sito')
    if @richiesta_admin.save

      redirect_to root_path, notice: 'Richiesta per diventare amministratore creata con successo.'
    end
  end
  


  def edit
  end

  
  def create
    @richiesta_admin = current_user.richiesta_admins.new(richiesta_admin_params)

    respond_to do |format|
      if @richiesta_admin.save
        format.html { redirect_to richiesta_admin_url(@richiesta_admin), notice: "Richiesta admin was successfully created." }
        format.json { render :show, status: :created, location: @richiesta_admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @richiesta_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    respond_to do |format|
      if @richiesta_admin.update(richiesta_admin_params)
        format.html { redirect_to richiesta_admin_url(@richiesta_admin), notice: "Richiesta admin was successfully updated." }
        format.json { render :show, status: :ok, location: @richiesta_admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @richiesta_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @richiesta_admin = current_user.richiesta_admins.find(params[:id])
    @richiesta_admin.destroy

    respond_to do |format|
      format.html { redirect_to richiesta_admins_url, notice: "Richiesta admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

 
    def set_richiesta_admin
      @richiesta_admin = RichiestaAdmin.find(params[:id])
    end

    def richiesta_admin_params
      params.require(:richiesta_admin).permit(:user_id, :content)
    end


  
end
