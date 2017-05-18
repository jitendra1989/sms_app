class MgRolesPermissionsController < ApplicationController
    before_filter :login_required
   layout "mindcom"
   before_action :set_mg_roles_permission, only: [:show, :edit, :update, :destroy]
#com
  # GET /mg_actions
  # GET /mg_actions.json
  def index
    @mg_roles_permissions = MgRolesPermission.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /mg_roles_permissions/1
  # GET /mg_roles_permissions/1.json
  def show
  end

  # GET /mg_roles_permissions/new
  def new
    @mg_roles_permission = MgRolesPermission.new
    render :layout => false
  end

  # GET /mg_roles_permissions/1/edit
  def edit
    render :layout => false
  end

  # POST /mg_roles_permissions
  # POST /mg_roles_permissions.json
  def create
    
    mg_action_ids=params[:action_ids]
    puts "Mg Action Id"
    puts mg_action_ids

    mg_action_ids=params[:action_ids]
    mg_action_ids.each do |action_id|
      mg_roles_permission = MgRolesPermission.new(mg_roles_permission_params)
      permission_id=MgPermission.where(:mg_action_id=>action_id,:mg_model_id=>params[:mg_model_id]).pluck(:id)
      mg_roles_permission.mg_permission_id=permission_id[0]
      mg_roles_permission.mg_school_id=params[:mg_school_id]
      mg_roles_permission.save
    end
      redirect_to '/mg_roles_permissions'


  end

  # PATCH/PUT /mg_roles_permissions/1
  # PATCH/PUT /mg_roles_permissions/1.json
  def update
    @mg_roles_permission.update(mg_roles_permission_params)
    @mg_roles_permission.mg_school_id=params[:mg_school_id]
    @mg_roles_permission.save
    redirect_to '/mg_roles_permissions'
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

  # DELETE /mg_roles_permissions/1
  # DELETE /mg_roles_permissions/1.json
  def destroy
    @mg_roles_permission.destroy
    respond_to do |format|
      format.html { redirect_to mg_roles_permissions_url, notice: 'Mg roles permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @mg_roles_permission = MgRolesPermission.find(params[:id])
    @mg_roles_permission.destroy
     redirect_to '/mg_roles_permissions'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_roles_permission
      @mg_roles_permission = MgRolesPermission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_roles_permission_params
      params.require(:mg_roles_permission).permit(:mg_role_id)
    end
end
