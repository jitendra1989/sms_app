class MgPermissionsController < ApplicationController
    before_filter :login_required
   layout "mindcom"
   before_action :set_mg_permission, only: [:show, :edit, :update, :destroy]

#com
  # GET /mg_actions
  # GET /mg_actions.json
  def index
    @mg_permissions = MgPermission.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /mg_permissions/1
  # GET /mg_permissions/1.json
  def show
  end

  # GET /mg_permissions/new
  def new
    @type="new"
    @mg_permission = MgPermission.new
    render :layout => false
  end

  # GET /mg_permissions/1/edit
  def edit
    @type="edit"
    render :layout => false
  end

  # POST /mg_permissions
  # POST /mg_permissions.json
  def create

    mg_action_ids=params[:action_ids]
    mg_action_ids.each do |action_id|
      #mg_roles_permission = MgRolesPermission.new(mg_roles_permission_params)
      @mg_permission = MgPermission.new
      @mg_permission.mg_model_id=params[:mg_permission][:mg_model_id] #=MgPermission.where(:mg_action_id=>action_id,:mg_model_id=>params[:mg_model_id]).pluck(:id)
      @mg_permission.mg_action_id=action_id
      #mg_roles_permission.mg_permission_id=permission_id[0]
      @mg_permission.save
    end

    #@mg_permission = MgPermission.new(mg_permission_params)
    #@mg_permission.save
      redirect_to '/mg_permissions'

   
  end

  # PATCH/PUT /mg_permissions/1
  # PATCH/PUT /mg_permissions/1.json
  def update
     @mg_permission.update(mg_permission_params)
      redirect_to '/mg_permissions'
    
  end

  # DELETE /mg_permissions/1
  # DELETE /mg_permissions/1.json
  def destroy
    @mg_permission.destroy
    respond_to do |format|
      format.html { redirect_to mg_permissions_url, notice: 'Mg permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @mg_permission = MgPermission.find(params[:id])
    @mg_permission.destroy
     redirect_to '/mg_permissions'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_permission
      @mg_permission = MgPermission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_permission_params
      params.require(:mg_permission).permit(:mg_model_id, :mg_action_id)
    end
end
