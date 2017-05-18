
class MgModelsController < ApplicationController
    before_filter :login_required
   layout "mindcom"
   before_action :set_mg_model, only: [:show, :edit, :update, :destroy]
#com
  # GET /mg_models
  # GET /mg_models.json
  def index
    @mg_models = MgModel.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /mg_models/1
  # GET /mg_models/1.json
  def show
  end

  # GET /mg_models/new
  def new
    @mg_model = MgModel.new
    render :layout => false
  end

  # GET /mg_models/1/edit
  def edit
    render :layout => false
  end

  # POST /mg_models
  # POST /mg_models.json
  def create
    @mg_model = MgModel.new(mg_model_params)
    @mg_model.save
      redirect_to '/mg_models'

  end

  # PATCH/PUT /mg_models/1
  # PATCH/PUT /mg_models/1.json
  def update
     @mg_model.update(mg_model_params)
      redirect_to '/mg_models'
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

  # DELETE /mg_models/1
  # DELETE /mg_models/1.json
  def destroy
    @mg_model.destroy
    respond_to do |format|
      format.html { redirect_to mg_models_url, notice: 'Mg model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def delete
    @mg_model = MgModel.find(params[:id])
    @mg_model.destroy
     redirect_to '/mg_models'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mg_model
      @mg_model = MgModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mg_model_params
      params.require(:mg_model).permit(:model_name, :description,:index)
    end
end
