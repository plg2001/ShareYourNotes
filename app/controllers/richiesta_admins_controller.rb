class RichiestaAdminsController < ApplicationController
  before_action :set_richiesta_admin, only: %i[ show edit update destroy ]

  # GET /richiesta_admins or /richiesta_admins.json
  def index
    @richiesta_admins = RichiestaAdmin.all
  end

  # GET /richiesta_admins/1 or /richiesta_admins/1.json
  def show
  end

  # GET /richiesta_admins/new
  def new
    @richiesta_admin = RichiestaAdmin.new
  end
 
  def create_richiesta_admin
    @richiesta_admin = RichiestaAdmin.new(user_id: current_user.id, content: 'Salve desidero diventare un amministratore del vostro sito')
    if @richiesta_admin.save
      # La tupla è stata creata con successo
      redirect_to root_path, notice: 'RichiestaAdmin creata con successo.'
    else
      # La creazione della tupla ha fallito
      render :new
    end
  end
  


  # GET /richiesta_admins/1/edit
  def edit
  end

  # POST /richiesta_admins or /richiesta_admins.json
  def create
    @richiesta_admin = RichiestaAdmin.new(richiesta_admin_params)

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

  
  # PATCH/PUT /richiesta_admins/1 or /richiesta_admins/1.json
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

  # DELETE /richiesta_admins/1 or /richiesta_admins/1.json
  def destroy
    @richiesta_admin.destroy

    respond_to do |format|
      format.html { redirect_to richiesta_admins_url, notice: "Richiesta admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

 
    # Use callbacks to share common setup or constraints between actions.
    def set_richiesta_admin
      @richiesta_admin = RichiestaAdmin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def richiesta_admin_params
      params.require(:richiesta_admin).permit(:user_id, :content)
    end


  
end
