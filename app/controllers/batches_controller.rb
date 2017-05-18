class BatchesController < ApplicationController
	#layout false
	#com
	  before_filter :login_required
	def batcheList

		   	puts "StudentsHash -- is comming "

		  	@sql = "Select id,name, start_date, end_date from mg_batches where mg_course_id = #{params[:id]} and is_deleted = '0' and mg_school_id = #{session[:current_user_school_id]} "
		  	@batch_list = MgBatch.find_by_sql(@sql)

		  	# @timeformat=MgSchool.find_by_id(5)
		  	# @batch_list[0].start_date = @batch_list[0].start_date.strftime(@timeformat.date_format)
		  	# # each loop
		  	# puts "Batch List"
     #        puts @batch_list[0].start_date
		  	#  puts 

		  	#  @timeformat=MgSchool.find_by_id(5)
		  	#  puts @timeformat.inspect

		  	#  actualDate = @batch_list[0].start_date.strftime(@timeformat.date_format)
     #         puts actualDate

     #         @batch_list[0].start_date = actualDate

     #         puts "batch date"

     #         puts @batch_list[0].start_date


     		

		  	respond_to do |format|
		       format.json  { render :json => @batch_list }
		    end
				
	end
	def edit
		@batch = MgBatch.find(params[:id])
	    render :layout => false
	end

	def show
		
	end

	def update
		MgBatch.transaction do
		 @batch = MgBatch.find(params[:id])
		 @batch.update(mg_batch_params)

         @timeformat=MgSchool.find_by_id(@batch.mg_school_id)

         puts @timeformat.inspect
        # puts params[:start_date]
         puts params[:mg_batch][:start_date]

		  @startSaveDate = Date.strptime(params[:mg_batch][:start_date],@timeformat.date_format)
		  @endSaveDate = Date.strptime(params[:mg_batch][:end_date],@timeformat.date_format)

		 @batch.update(:start_date => @startSaveDate,:end_date => @endSaveDate)
	
	#	@batch.update()
		 redirect_to '/classes'
	end

	end
	def destroy
		puts "Destroy is called"
		@batch = MgBatch.find(params[:id])
		@batch.update(:is_deleted => 1)
		#Added By Bindhu
		@batch_list=MgBatch.where(:mg_course_id=>@batch.mg_course_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
		
		respond_to do |format|
				format.json { render :json => @batch_list }
		end
		# redirect_to '/classes'
	end


	def create
		logger.info "Batch controlle will going to create"
		#puts params[:mg_course_id]
MgBatch.transaction do
		@batch = MgBatch.new(:mg_course_id => params[:mg_course_id],:name => params[:name],:start_date => params[:start_date],:end_date => params[:end_date],:is_deleted => 0,:mg_school_id => session[:current_user_school_id] )
		#@batch.save

		respond_to do |format|
			if @batch.save
				format.html { redirect_to '/batches/show', notice: 'Person was successfully created.' }
     
				# format.js   { render action: 'show', status: :created, location: '/batch' }
   
   
			end

		end
	end
	end

	private

	def batch_params
		params.require(:batch_val).permit(:mg_course_id)
	end
	def mg_batch_params
		params.require(:mg_batch).permit(:name,:start_date,:end_date)
	end

end
