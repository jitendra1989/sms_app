class MgActionsController < ApplicationController
    before_filter :login_required
   layout "mindcom"
	 before_action :set_mg_action, only: [:show, :edit, :update, :destroy]

#com
  # GET /mg_actions
  # GET /mg_actions.json
  def index
    @mg_actions = MgAction.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /mg_actions/1
  # GET /mg_actions/1.json
  def show
  end

  # GET /mg_actions/new
  def new
    @mg_action = MgAction.new
    render :layout => false
  end

  # GET /mg_actions/1/edit
  def edit
    render :layout => false
  end

  # POST /mg_actions
  # POST /mg_actions.json
  def create
    @mg_action = MgAction.new(mg_action_params)
    @mg_action.save
      redirect_to '/mg_actions'

  end

  # PATCH/PUT /mg_actions/1
  # PATCH/PUT /mg_actions/1.json
  def update
     @mg_action.update(mg_action_params)
      redirect_to '/mg_actions'
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

  # DELETE /mg_actions/1
  # DELETE /mg_actions/1.json
  def destroy
    @mg_action.destroy
    respond_to do |format|
      format.html { redirect_to mg_actions_url, notice: 'Mg action was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @mg_action = MgAction.find(params[:id])
    @mg_action.destroy
     redirect_to '/mg_actions'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_action
      @mg_action = MgAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_action_params
      params.require(:mg_action).permit(:action_name, :description)
    end
end
