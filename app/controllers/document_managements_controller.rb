class DocumentManagementsController < ApplicationController
	# require 'carrierwave/orm/activerecord'
  require 'open-uri'
  before_filter :login_required
   layout "mindcom"

	 def index
    @document_managements = MgDocumentManagement.where(:is_deleted=>0)
    # @images = Dir.glob("app/assets/images/slide/*")
    # @images = Dir.glob("app/assets/images/slide/*.jpg")

  end

def new
	# dir = File.dirname("#{Rails.root}/public/MyFile/abc.txt")
	# FileUtils.mkdir_p(dir) unless File.directory?(dir)
  id=session[:user_id]
  @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
    @document_managements = MgDocumentManagement.new
    @mg_employee_folder_id=params[:mg_employee_folder_id]
  render :layout => false

  end
def create
    require 'mime/types'
  
    # @postdata = User.demo(params[:upload])
    # u = MyFile.new
    # u.file = params[:files] # Assign a file like this, or
    # # u.avatar = [File.open('somewhere')]# like this
    # u.save!
    # u.file[0].url # => '/url/to/file.png'
    # u.file[0].current_path # => 'path/to/file.png'
    # u.file[0].identifier # => 'file.png'

    @document_managements = MgDocumentManagement.new(document_managements_params)

    if @document_managements.save
      redirect_to action: 'folder_index', notice: 'File uploaded successfully.'
    else
      render action: 'new', alert: 'File upload could not be created.' 
    end
  end

 def create_folder
 # 	log_file_name = '/path/to/my.log'
	# unless File.exist?(File.dirname(log_file_name))
	#   FileUtils.mkdir_p(File.dirname(log_file_name))
	# end
	dir = File.dirname("#{Rails.root}/log/public/MyFile")


 		
 end

 def folder_new
  id=session[:user_id]
  @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
  @mg_employee_folder_id=params[:mg_employee_folder_id]
  @document_managements=MgEmployeeFolder.new
  render :layout => false

   
 end

 def folder_show
   
 end

 def folder_new_create
   @document_managements = MgEmployeeFolder.new(folder_managements_params)

    if @document_managements.save
      redirect_to action: 'folder_index', notice: 'Folder created successfully. '
    else
      render action: 'folder_new'
    end
   
 end

 def folder_edit
    @document_managements = MgEmployeeFolder.find(params[:id])

   
 end

 def folder_index
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
    @document_managements = MgEmployeeFolder.where(:is_deleted=>0, :mg_employee_chaild_folder_id=>0, :mg_employee_id=>@employee[0], :mg_school_id=>session[:current_user_school_id])



    #sharing

    @shared=MgBatchDocument.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_employee_id=>@employee[0]).order('mg_batch_id ASC')#.paginate(page: 
   
 end
 def folder_update
    @document_managements = MgEventType.find(params[:id])
     
      if @document_managements.update(folder_managements_params)
        redirect_to 'folder_index'
      else
        render 'folder_edit'
      end
 end


  def display_segment( node )
    
    html = "<li>"
    node_class = node.length == 0 ? "file" : "folder"
    html << "<span class=\"#{node_class}\">#{h(node.to_s)} </span>"
    html << "<ul id=\"children_of_#{h(node.folder_name)}\">"
    node.each{|child_node|
      
      html << display_segment( child_node )
    }
    html << "</ul></li>"
  end

  
  def view_file_in_list

    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
    @document_managements = MgDocumentManagement.where(:is_deleted=>0, :mg_user_id=>session[:user_id], :mg_employee_folder_id=>params[:id])
    # @document_managements = MgDocumentManagement.where(:is_deleted=>0, :mg_employee_id=>@employee[0], :mg_employee_folder_id=>params[:id])
    puts "sub folder find---1"
    puts params[:subfolderID] 
    @mg_employee_folder_id=params[:id]
    puts "sub folder find---1"


    @folder=MgEmployeeFolder.where(:mg_employee_chaild_folder_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @folder1=MgEmployeeFolder.find(params[:id])
  render :layout => false

  end

 

def delete_file
if params[:delete_share]=="share"
    # @dac=MgBatchDocument.find_by_mg_document_management_id(params[:id])
    @dac=MgBatchDocument.find(params[:id])

    @dac.is_deleted=1
    @dac.save
    else           
      @document_managements=MgDocumentManagement.find_by_id(params[:id])
      @document_managements.is_deleted =1
      @document_managements.save

      @batchDocument=MgBatchDocument.where(:mg_document_management_id=>params[:id], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
        if @batchDocument.present?
              @batchDocument.each do |delete|
              @object=MgBatchDocument.find(delete.id)
              @object.is_deleted=1
              @object.save
        end
      end
    end
    redirect_to :action=>'folder_index'

  
end
def delete_folder

   @document_managements=MgEmployeeFolder.find_by_id(params[:id])
      @document_managements.is_deleted =1
      @document_managements.save
    redirect_to :action=>'folder_index'

end

def folder_index_try
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
    @document_managements = MgEmployeeFolder.where(:is_deleted=>0, :mg_employee_chaild_folder_id=>0, :mg_employee_id=>@employee[0])
end

 def view_file_in_sub_folder_list
  # subfolderID: splString[0], count: splString[0]
    @subfolderID=params[:subfolderID]
    @count=params[:count]
    id=session[:user_id]
    @employee = MgEmployee.where(:mg_user_id =>id).pluck(:id)
    @document_managements = MgDocumentManagement.where(:is_deleted=>0, :mg_user_id=>session[:user_id], :mg_employee_folder_id=>params[:subfolderID], :mg_school_id=>session[:current_user_school_id])
    render :layout => false

  end

  def share_file_for_batch
  # @batchs=MgBatch.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
  @document_management_id=params[:id]

  @course_list=MgCourse.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)

    render :layout => false
end

def share_file_for_batch_save
   @mg_employee_id=MgEmployee.find_by_mg_user_id(session[:user_id])
    @batch_content=MgBatchDocument.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>params[:contents][:mg_school_id],  :mg_document_management_id=>params[:contents][:mg_document_management_id] )
    if @batch_content.present?   
      @batch_content[0].update(document_params)
      @batch_content[0].mg_employee_id= @mg_employee_id.id
      @batch_content[0].mg_batch_id=params[:mg_batch_id]
      @batch_content[0].save
      @notice ="Shared Document Updated Successfully"
    else
      @batch_content=MgBatchDocument.new(document_params)
      @batch_content.mg_employee_id=@mg_employee_id.id
       @batch_content.mg_batch_id=params[:mg_batch_id]
      @batch_content.save
      @notice ="Document shared successfully. "

    end

    redirect_to action:'folder_index', notice: @notice
  
end

def files_for_student
  school_id=session[:current_user_school_id]
  @student=MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :mg_user_id=>session[:user_id]).pluck(:mg_batch_id)
  
  @document_managements=MgDocumentManagement.where(:is_deleted=>0, :mg_batch_id=>@student[0], :mg_school_id=>school_id)#.paginate(page: params[:page], per_page: 10)
  @document_managements=MgBatchDocument.where(:is_deleted=>0,:mg_batch_id=>@student[0], :mg_school_id=>school_id)
  # @shared=MgMyQuestion.where(:is_deleted=>0, :mg_school_id=>school_id, :mg_batch_id=>@student)
  @shared=MgBatchContent.where(:is_deleted=>0, :mg_school_id=>school_id,:mg_batch_id=>@student)#.paginate(page: params[:page], per_page: 10)
end

def folder_table_show
  
end

def content_show_for_student
  @my_questions=MgMyQuestion.find(params[:id])
    render :layout => false

end

def download_html
  # ...
  if params[:download]
    send_data(render_to_string, :filename => "object.html", :type => "text/html")
  else
    # render normally
  end
end

private
    def folder_managements_params
      params.require(:document_managements).permit(:folder_name, :mg_employee_id, :is_deleted, :mg_employee_chaild_folder_id, :mg_school_id, :created_by, :updated_by)
      
    end

    def document_params
    params.require(:contents).permit(:mg_batch_id, :mg_employee_id, :mg_document_management_id, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end

    def document_managements_params
      params.require(:document_managements).permit(:name, :file, :mg_user_id, :is_deleted, :mg_employee_folder_id, :mg_school_id, :created_by, :updated_by)
    end
end
