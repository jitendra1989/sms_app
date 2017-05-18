class DynamicLoadersController < ApplicationController
  #com
	layout "mindcom"
	  before_filter :login_required
  def index

  end

  def new
  	render :layout => false
  end

  def edit
  	render :layout => false
  end
end
