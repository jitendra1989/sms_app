class UsersController < ApplicationController
  #comments
      before_filter :login_required
  def index
  end

  def new
    
  end
  
  def create
  	 #  render plain: params[:user].inspect
  	 @user = MgUser.new(user_params)
      


  	 if @user.save
     	# redirect_to @user
     	render :layout => false
     end
  	
  end

    private

  def user_params
    params.require(:user).permit(:user_name, :first_name, :middle_name, :last_name,:email, :password,:mg_school_id,:is_deleted,:user_type )
  end

end
