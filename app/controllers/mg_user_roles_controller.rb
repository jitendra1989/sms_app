class MgUserRolesController < ApplicationController
    before_filter :login_required
   layout "mindcom"
   before_action :set_mg_user_role, only: [:show, :edit, :update, :destroy]
#com
  # GET /mg_actions
  # GET /mg_actions.json
  def index
    @mg_user_roles = MgUserRole.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /mg_user_roles/1
  # GET /mg_user_roles/1.json
  def show
  end

  # GET /mg_user_roles/new
  def new
    @mg_user_role = MgUserRole.new
    render :layout => false
  end

  # GET /mg_user_roles/1/edit
  def edit
    render :layout => false
  end

  # POST /mg_user_roles
  # POST /mg_user_roles.json
  def create
    @mg_user_role = MgUserRole.new(mg_user_role_params)
    @mg_user_role.save
      redirect_to '/mg_user_roles'


  end

  # PATCH/PUT /mg_user_roles/1
  # PATCH/PUT /mg_user_roles/1.json
  def update
     @mg_user_role.update(mg_user_role_params)
      redirect_to '/mg_user_roles'
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

  # DELETE /mg_user_roles/1
  # DELETE /mg_user_roles/1.json
  def destroy
    @mg_user_role.destroy
    respond_to do |format|
      format.html { redirect_to mg_user_roles_url, notice: 'Mg mg_user_role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @mg_user_role = MgUserRole.find(params[:id])
    @mg_user_role.destroy
     redirect_to '/mg_user_roles'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_user_role
      @mg_user_role = MgUserRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_user_role_params
      params.require(:mg_user_role).permit(:mg_user_id, :mg_role_id)
    end
end
