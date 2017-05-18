class MgRolesController < ApplicationController
   layout "mindcom"
       before_filter :login_required
   before_action :set_mg_role, only: [:show, :edit, :update, :destroy]
#com
  # GET /mg_roles
  # GET /mg_roles.json
  def index
    @mg_roles = MgRole.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /mg_roles/1
  # GET /mg_roles/1.json
  def show
  end

  # GET /mg_roles/new
  def new
    @mg_role = MgRole.new
    render :layout => false
  end

  # GET /mg_roles/1/edit
  def edit
    render :layout => false
  end

  # POST /mg_roles
  # POST /mg_roles.json
  def create
    @mg_role = MgRole.new(mg_role_params)
    @mg_role.save
      redirect_to '/mg_roles'

    
  end

  # PATCH/PUT /mg_roles/1
  # PATCH/PUT /mg_roles/1.json
  def update
     @mg_role.update(mg_role_params)
      redirect_to '/mg_roles'
    # respond_to do |format|
    #   if @mg_action.update(mg_action_params)
    #     format.html { redirect_to @mg_action, notice: 'Mg action was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @mg_action }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @mg_action.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /mg_roles/1
  # DELETE /mg_roles/1.json
  def destroy
    @mg_role.destroy
    respond_to do |format|
      format.html { redirect_to mg_roles_url, notice: 'Mg role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @mg_role = MgRole.find(params[:id])
    @mg_role.destroy
     redirect_to '/mg_roles'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_role
      @mg_role = MgRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_role_params
      params.require(:mg_role).permit(:role_name, :description)
    end
end