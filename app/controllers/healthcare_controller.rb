class HealthcareController < ApplicationController
  before_filter :login_required
  # before_filter :authorization, :except => [:index, :incharge]
  layout "mindcom"
  
  def new
  	@action='new'
    @checkup_type_data=MgCheckupType.new
  end

  def index
  	@checkup_type_data=MgCheckupType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def create
    array=[]
    @temp=0
    begin
      MgCheckupType.transaction do
      	@checkup_type_params=MgCheckupType.new(checkup_type_params_data)
     		array.push(@checkup_type_params.save)
  	 	  @particularTypeData=params[:particulars]
  	    @applicableData=params[:applicable]
      	# for i in 0...@particularTypeData.size
        if params[:particulars].present?
          params[:particulars].each do |k,v|
    	      @saveParticularType=MgCheckupParticular.new()
            @saveParticularType.particulars=v
    	      @saveParticularType.normal=params[:normal][k]

    	      @saveParticularType.applicable=@applicableData[k.to_i]

    	      @saveParticularType.show_in_healthcard=params[:show_in_healthcard].present? ? params[:show_in_healthcard][k.to_s] : nil

    	      @saveParticularType.mg_checkup_type_id=@checkup_type_params.id
    	      @saveParticularType.is_deleted=0
    	      @saveParticularType.created_by=session[:user_id]
    	      @saveParticularType.updated_by=session[:user_id]
    	      @saveParticularType.mg_school_id=session[:current_user_school_id]
    	      array.push(@saveParticularType.save)
          end
      	end

        if array.include?(false)
          raise ActiveRecord::Rollback
        end
      end
      flash[:notice]= "Checkup Type saved successfully"
    rescue Exception => e
      @temp=1
      flash[:error]="Error Occured please check duplicate name"
      puts e
    end
    if array.include?(false)
      flash[:error]="Error Occured please check duplicate name"
      redirect_to :back
    else
      if @temp==0
        flash[:notice]= "Checkup Type saved successfully"
      end
    end
      redirect_to :action=> "index"
  end


  def update
    # puts pararfgfghfdgfggms
    array=[]
    begin
      MgCheckupType.transaction do
      	update_data=MgCheckupType.find(params[:id])
      	update_particulardata=MgCheckupParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_checkup_type_id=>params[:id])
        update_particulardata.update_all(:is_deleted=>1)
      	@updateparticulars=params[:particulars]
      	@updateApplicable=params[:applicable]
    	  @updateShowCheckbox=params[:show_in_healthcard]
        update_data.name=params[:checkup_type][:name]
        update_data.description=params[:checkup_type][:description]
        update_data.updated_by=session[:user_id]
        array.push(update_data.save)

    	  # for i in 0...@updateparticulars.size
        count=0
        if params[:particulars].present?
          params[:particulars].each do |k,v|
            update_particulardata=MgCheckupParticular.find_by(:mg_checkup_type_id=>params[:id], :mg_school_id=>params[:checkup_type][:mg_school_id], :id=>k)
            if update_particulardata.present?
              update_particulardata.particulars=v
              update_particulardata.normal=params[:normal][k]
              update_particulardata.applicable=@updateApplicable[count]
              update_particulardata.show_in_healthcard=@updateShowCheckbox.present? ? @updateShowCheckbox[count.to_s] : nil
              update_particulardata.is_deleted=0
              update_particulardata.updated_by=session[:user_id]
              array.push(update_particulardata.save)
            else
              new_record=MgCheckupParticular.new(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
              new_record.particulars=v
              new_record.mg_checkup_type_id=params[:id]
              new_record.applicable=@updateApplicable[count]
              new_record.show_in_healthcard=@updateShowCheckbox.present? ? @updateShowCheckbox[count.to_s] : nil
              new_record.is_deleted=0
              array.push(new_record.save)
            end
            count+=1
    	    end
        end 
        if array.include?(false)
          raise ActiveRecord::Rollback
        end

      end#transaction

      if array.include?(false)
        flash[:error]="Error Occured please check duplicate name"
      else
        flash[:notice]= "Checkup Type upadted successfully"
      end
    rescue Exception => e
      flash[:error]="Error Occured please check duplicate name"
    end
	  redirect_to :action=>"index"
  end

  def edit
  	@action='edit'
  	@checkup_type_data=MgCheckupType.find(params[:id])
  	@particularTypeData=MgCheckupParticular.where(:mg_checkup_type_id=>params[:id], :mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
  end

  def delete
    begin
      
      MgCheckupType.transaction do

        delete_checkup_type_data=MgCheckupType.find(params[:id])
        delete_checkup_type_data.is_deleted=1
        delete_checkup_type=MgCheckupParticular.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_checkup_type_id=>params[:id])
        if delete_checkup_type_data.save & delete_checkup_type.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
          schedule_list=MgCheckUpSchedule.where(:mg_check_up_type_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          if schedule_list.present?
            schedule_list.each do |schedule|
              schedule.update(:is_deleted=>1,:updated_by=>session[:user_id])
              schedule_record_list=MgCheckUpScheduleRecord.where(:mg_check_up_schedule_id=>schedule.id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
              if schedule_record_list.present?
                schedule_record_list.each do |schedule_record|
                  schedule_record.update(:is_deleted=>1,:updated_by=>session[:user_id])
                end
              end
            end
          end
          schedule_record_list_with_checkup_type_id=MgCheckUpScheduleRecord.where(:mg_check_up_type_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

          if schedule_record_list_with_checkup_type_id.present?
            schedule_record_list_with_checkup_type_id.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
          end
          health_test=MgHealthTest.where(:mg_check_up_type_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          if health_test.present?
            health_test.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
          end

          flash[:notice] = "Checkup Type deleted Successfully "
        else
          flash[:error] = "Checkup Type deleted unsuccessfully"
        end
      end#end transaction
    rescue Exception => e
      flash[:error]="Error Occured"
      puts e
    end
    redirect_to :action=>"index"
  end

  def show
  	@checkup_type_data=MgCheckupType.find_by(:id=>params[:id])
    @particularTypeData=MgCheckupParticular.where(:mg_checkup_type_id=>params[:id], :is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    	
  	#render :layout=>false
  end


  def vaccinations
    @vaccinations=MgVaccination.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  def new_vaccinations
    @action='new'
    @vaccinations=MgVaccination.new
    render :layout=>false
  end

  def create_vaccinations
    @vaccinations=MgVaccination.new(params_vaccinations)
    if @vaccinations.save
      flash[:notice]="Vaccination created successfully"
    else
      flash[:error]="Error Occured please check duplicate name"
    end
    redirect_to :back#:action=>'vaccinations'
  end

  def edit_vaccinations
    @action='edit'
    @vaccinations=MgVaccination.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def update_vaccinations
    @vaccinations=MgVaccination.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    if @vaccinations.update(params_vaccinations)
        flash[:notice]="Vaccination updated successfully"
    else
      flash[:error]="Error Occured please check duplicate name"
    end
    redirect_to :back#:action=>'vaccinations'
  end

  def delete_vaccinations
    @vaccinations=MgVaccination.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    vaccination_detail=MgVaccinationDetail.where(:mg_vaccination_id=>@vaccinations.id,:is_deleted=>0)
    if @vaccinations.update(:is_deleted=>1)
      vaccination_detail.each do |vaccination_record|
        vaccination_record.update(:is_deleted=>1,:updated_by=>session[:user_id])
      end
      flash[:notice]="Vaccination deleted successfully"
    else
      flash[:error]="Vaccination deleted unsuccessfully"
    end
    redirect_to :back#:action=>'vaccinations'
  end
  def show_vaccinations
    @vaccinations=MgVaccination.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end


  def booster_doses
    @booster_doses=MgBoosterDose.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  def new_booster_doses
    @action='new'
    @booster_doses=MgBoosterDose.new
    render :layout=>false
  end

  def create_booster_doses
    @booster_doses=MgBoosterDose.new(params_booster_doses)
    if @booster_doses.save
      flash[:notice]="Vaccination created successfully"
    else
      flash[:error]="Error Occured please check duplicate name"
    end
    redirect_to :back#:action=>'vaccinations'
  end

  def edit_booster_doses
    @action='edit'
    @booster_doses=MgBoosterDose.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def update_booster_doses
    @booster_doses=MgBoosterDose.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    if @booster_doses.update(params_booster_doses)
        flash[:notice]="Booster Doses updated successfully"
    else
      flash[:error]="Error Occured please check duplicate name"
    end
    redirect_to :back#:action=>'vaccinations'
  end

  def delete_booster_doses
    @booster_doses=MgBoosterDose.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    booster_detail=MgBoosterDoseDetail.where(:mg_booster_dose_id=>@booster_doses.id,:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    if @booster_doses.update(:is_deleted=>1)
      booster_detail.each do |booster_detail|
        booster_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
      end
      flash[:notice]="Booster Doses deleted successfully"
    else
      flash[:error]="Booster Doses deleted unsuccessfully"
    end
    redirect_to :back#:action=>'vaccinations'
  end
  def show_booster_doses
    @booster_doses=MgBoosterDose.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def vaccinations_list
    student_id=params[:mg_student_id]
    @school=MgSchool.find(session[:current_user_school_id])
    @vaccinations=MgVaccination.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @vaccination_detail=MgVaccinationDetail.where(:mg_student_id=> params[:mg_student_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @vaccination_particular=MgVaccinationDetail.where(:mg_student_id=> params[:mg_student_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:is_particular_student=>true)
    @booster_doses=MgBoosterDose.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @booster_doses_detail=MgBoosterDoseDetail.where(:mg_student_id=> params[:mg_student_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    if @booster_doses_detail.present?
      @booster_doses.each do |check_dose|
        temp=0
        @booster_doses_detail.each do |check_doses_det|
          if check_doses_det.mg_booster_dose_id==check_dose.id
            temp=temp+1
          end
        end
        if temp==0
          data_detail=MgBoosterDoseDetail.new
          data_detail.mg_booster_dose_id=check_dose.id
          data_detail.mg_student_id=params[:mg_student_id]
          data_detail.mg_school_id=session[:current_user_school_id]
          data_detail.is_deleted=0
          data_detail.save
        end
      end
    end
    @booster_doses_detail=MgBoosterDoseDetail.where(:mg_student_id=> params[:mg_student_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @booster_doses_particular=MgBoosterDoseDetail.where(:mg_student_id=> params[:mg_student_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:is_particular_student=>true)
    render :layout=>false
  end


  def booster_doses_list
    params[:mg_student_id]
    @school=MgSchool.find(session[:current_user_school_id])
    @booster_doses=MgBoosterDose.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    @booster_doses_detail=MgBoosterDoseDetail.where(:mg_student_id=> params[:mg_student_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
    render :layout=>false

  end

  def multi_task_worker
    puts params.inspect
    mg_school_id=session[:current_user_school_id]
    @obj=nil
    if session[:user_type]=="guardian"
      str='<option value="">Select</option>'
      student_id=MgGuardian.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_student_id)
      student=MgStudent.where(:id=>student_id,:is_deleted=>0, :mg_school_id=>mg_school_id).order(:first_name,:last_name)
      student.each do |s|
        str +="<option value=#{s.id}>#{s.admission_number} #{" - "} #{s.try(:first_name).try(:capitalize)} #{s.try(:last_name).try(:capitalize)}</option>"
      end
      @obj=str
    else
      if params[:selecter]=="selectCourseFromAcademicYear"
        str='<option value="">Select</option>'
        academic_years  =   MgTimeTable.find_by(:id=>params[:mg_time_table_id])#where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        batch_obj=MgBatch.where(" start_date BETWEEN '#{academic_years.start_date}' AND '#{academic_years.end_date}' AND  end_date  BETWEEN '#{academic_years.start_date}' AND '#{academic_years.end_date}' AND is_deleted=0 AND mg_school_id=#{session[:current_user_school_id]}").order(:mg_course_id)
        puts batch_obj.inspect
        batch_obj.each do |b|
          str +="<option value=#{b.id}>#{b.course_batch_name}</option>"
        end
        @obj=str
      elsif params[:selecter]=="selectStudentFromBatch"
        str='<option value="">Select</option>'
        student=MgStudent.where(:is_deleted=>0, :mg_school_id=>mg_school_id, :mg_batch_id=>params[:mg_batch_id]).order(:first_name,:last_name)

        student.each do |s|
          str +="<option value=#{s.id}>#{s.admission_number} #{' - '} #{s.try(:first_name).try(:capitalize)} #{s.try(:last_name).try(:capitalize)}</option>"
        end
        @obj=str
      end
    end
      
    
    render :json=>{:data=>@obj}
  end

  def immunization_vaccinations
    if session[:user_type]=="guardian"
      student_id=MgGuardian.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_student_id).uniq
      vaccin_student=MgVaccinationDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)
      @student=MgStudent.where("is_deleted = ? and mg_school_id IN (?) and id IN (?) and id =?",0,session[:current_user_school_id],vaccin_student,student_id).order(:first_name,:last_name).paginate(page: params[:page], per_page: 10)
    else
      @student=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :id=>MgVaccinationDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)).order(:first_name,:last_name).paginate(page: params[:page], per_page: 10)
    end
  end
  def new_immunization_vaccinations
    @time_table=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  end

  def create_immunization_vaccinations
    current_student_data=MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>params[:mg_student_id])
    current_student_data.each do |curr_stu|
      curr_stu.update(:is_deleted=>1)
    end
    duess=params[:booster_due_date_cpy_id]
    datess=params[:booster_date_cpy_id]
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    begin
      MgVaccinationDetail.transaction do
        # ========================================================================
        booster_id=params[:booster_doses_details_id]
        for i in 0...params[:booster_doses_details_id].size
          if booster_id[i].present?
            booster_doses=MgBoosterDoseDetail.new
            booster_doses.mg_booster_dose_id=booster_id[i]
            booster_doses.mg_student_id=params[:mg_student_id]
            booster_doses.mg_batch_id=params[:mg_batch_id]
            booster_doses.mg_time_table_id=params[:mg_time_table_id]
            timeformat = MgSchool.find(session[:current_user_school_id])
            if duess[i].present?
            booster_doses.due_date=Date.strptime(duess[i],school.date_format)#date_due#Date.strptime(due_date_value[1],school.date_format)
            end
            if datess[i].present?
            booster_doses.date=Date.strptime(datess[i],school.date_format)#given_date#Date.strptime(date_value[1],school.date_format)
            end
            booster_doses.mg_school_id=session[:current_user_school_id]
            booster_doses.is_deleted=0
            booster_doses.created_by=session[:user_id]
            booster_doses.updated_by=session[:user_id]
            booster_doses.save
          end
        end
        # =========================================================================
        if params[:due_date].present?
          params[:due_date].each do |k,v|
            if v.present? || params[:vaccs_date][k].present?
              obj=MgVaccinationDetail.find_by(:is_deleted=>0,:mg_student_id=>params[:mg_student_id],:mg_vaccination_id=>k)
              if obj.present?
                if v.present?
                  obj.due_date=Date.strptime(v,school.date_format)
                else
                  obj.due_date=nil
                end
                if params[:vaccs_date][k].present?
                  obj.date=Date.strptime(params[:vaccs_date][k],school.date_format)
                else
                  obj.date=nil
                end
                obj.updated_by=session[:user_id]
                obj.save
              else
                vaccinations=MgVaccinationDetail.new(vaccinations_details_params)#:is_deleted=>0, :mg_school_id=>params[:vaccinations][:mg_school_id], :created_by=>params[:vaccinations][:created_by])
                vaccinations.mg_student_id=params[:mg_student_id]
                vaccinations.mg_vaccination_id=k
                if v.present?
                  vaccinations.due_date=Date.strptime(v,school.date_format)
                else
                  vaccinations.due_date=nil
                end
                if params[:vaccs_date][k].present?
                  vaccinations.date=Date.strptime(params[:vaccs_date][k],school.date_format)
                else
                  vaccinations.date=nil
                end
                vaccinations.mg_time_table_id=params[:mg_time_table_id]
                vaccinations.mg_batch_id=params[:mg_batch_id]
                vaccinations.save
              end
            else
              obj=MgVaccinationDetail.find_by(:is_deleted=>0,:mg_student_id=>params[:mg_student_id],:mg_vaccination_id=>k)
              if obj.present?
                obj.due_date=nil#Date.strptime(v,school.date_format)
                obj.date=nil#Date.strptime(v,school.date_format)
                obj.updated_by=session[:user_id]
                obj.save
              else
                vaccinations=MgVaccinationDetail.new(vaccinations_details_params)#:is_deleted=>0, :mg_school_id=>params[:vaccinations][:mg_school_id], :created_by=>params[:vaccinations][:created_by])
                vaccinations.mg_student_id=params[:mg_student_id]
                vaccinations.mg_vaccination_id=k
                vaccinations.due_date=nil#Date.strptime(v,school.date_format)
                vaccinations.date=nil#Date.strptime(v,school.date_format)
                vaccinations.mg_time_table_id=params[:mg_time_table_id]
                vaccinations.mg_batch_id=params[:mg_batch_id]
                vaccinations.save
              end
            end
          end
        end
        if params[:immunization][0].present?
          params[:immunization].each_with_index do |immunization_value,index|
            if immunization_value.present?
              if params[:vaccination_due_date][index].present?
                vaccination_due_date =Date.strptime(params[:vaccination_due_date][index],school.date_format)
              else
                vaccination_due_date=nil
              end
              if params[:vaccination_date][index].present?
                vaccination_date =Date.strptime(params[:vaccination_date][index],school.date_format)
              else
                vaccination_date=nil
              end

              if params[:particular_details_id].present? && params[:particular_details_id][index].present?
                vaccination_detail = MgVaccinationDetail.find_by(:id=>params[:particular_details_id][index],:is_deleted=>0)
                vaccination_detail.update(:name=>immunization_value,:age_recommended=>params[:age_recommended][index],:is_particular_student=>true,:due_date=>vaccination_due_date,:date=>vaccination_date,:mg_time_table_id=>params[:mg_time_table_id],:mg_student_id=>params[:mg_student_id],
                :mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:updated_by=>session[:user_id])
              else
                vaccination_detail = MgVaccinationDetail.new(:name=>immunization_value,:age_recommended=>params[:age_recommended][index],:is_particular_student=>true,:due_date=>vaccination_due_date,:date=>vaccination_date,:mg_time_table_id=>params[:mg_time_table_id],:mg_student_id=>params[:mg_student_id],
                :mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                vaccination_detail.save
              end
            end
          end
        end
      end#end of transaction
      flash[:notice]="Student Immunization details updated successfully"
    rescue Exception => e
      flash[:error]="There is some Problem"
      puts e
    end
    redirect_to :action=>'immunization_vaccinations'
  end

  def immunization_particular
    if params[:immunization_record]=="vaccination"
      @vaccination_detail = MgVaccinationDetail.find_by(:id=>params[:id])
      @vaccination_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
      student_id=@vaccination_detail.try(:mg_student_id)
    else
      @booster_doses_detail = MgBoosterDoseDetail.find_by(:id=>params[:id])
      @booster_doses_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
      student_id=@booster_doses_detail.try(:mg_student_id)
    end
    respond_to do |format|
      format.json  { render :json => student_id.to_json }
    end
  end

  def create_immunization_booster_doses
    puts  params.inspect
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    begin
    MgBoosterDoseDetail.transaction do
      if params[:date].present?
        params[:date].each do |k,v|
          if v.present?
            obj=MgBoosterDoseDetail.find_by(:is_deleted=>0,:mg_student_id=>params[:mg_student_id],:mg_booster_dose_id=>k)
            if obj.present?
              obj.date=Date.strptime(v,school.date_format)
              obj.updated_by=session[:user_id]
              obj.save
            else
            vaccinations=MgBoosterDoseDetail.new(booster_doses_details_params)#:is_deleted=>0, :mg_school_id=>params[:vaccinations][:mg_school_id], :created_by=>params[:vaccinations][:created_by])
            vaccinations.mg_student_id=params[:mg_student_id]
            vaccinations.mg_booster_dose_id=k
            vaccinations.date=Date.strptime(v,school.date_format)
            vaccinations.mg_time_table_id=params[:mg_time_table_id]
            vaccinations.mg_batch_id=params[:mg_batch_id]
            vaccinations.save
            end #end if
          else
            obj=MgBoosterDoseDetail.find_by(:is_deleted=>0,:mg_student_id=>params[:mg_student_id],:mg_booster_dose_id=>k)
            if obj.present?
              obj.date=nil#Date.strptime(v,school.date_format)
              obj.updated_by=session[:user_id]
              obj.save
            else
              vaccinations=MgBoosterDoseDetail.new(booster_doses_details_params)#:is_deleted=>0, :mg_school_id=>params[:vaccinations][:mg_school_id], :created_by=>params[:vaccinations][:created_by])
              vaccinations.mg_student_id=params[:mg_student_id]
              vaccinations.mg_booster_dose_id=k
              vaccinations.date=nil#Date.strptime(v,school.date_format)
              vaccinations.mg_time_table_id=params[:mg_time_table_id]
              vaccinations.mg_batch_id=params[:mg_batch_id]
              vaccinations.save
            end
          
          end#end v if
        end#end v loop
      end#end  if
    end
      flash[:notice]="Student Booster Doses details updated successfully"
    rescue Exception => e
       flash[:error]="Student Booster Doses details updated unsuccessfully"
       puts e
    end
    redirect_to :action=>'immunization_booster_doses'
  end
  def show_immunization_vaccinations
    puts"student_idiiiiiiiiiiii"
    puts params
    puts"student_idiiiiiiiiiiii"
    @vaccinations=MgVaccinationDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_student_id=>params[:id])
    @booster_detail=MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_student_id=>params[:id])
    @student=MgStudent.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:id])
    @school=MgSchool.find(session[:current_user_school_id])
    render :layout=>false
  end
  def edit_immunization_vaccinations
    @time_table=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @vaccinations=MgVaccinationDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_student_id=>params[:id])
    @mg_time_table_id=@vaccinations[0].try(:mg_time_table_id)
    @mg_batch_id=@vaccinations[0].try(:mg_batch_id)
    @batch =MgBatch.find_by(:id=>@vaccinations[0].try(:mg_batch_id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @batch_slect=[@batch.try(:course_batch_name),  @batch.try(:id)]
    @student=MgStudent.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:id])
    @student_select=["#{@student.admission_number} #{' - '} #{@student.first_name.capitalize} #{@student.last_name.capitalize}", @student.id]
  end
  def delete_immunization_vaccinations
    @vaccinations=MgVaccinationDetail.where(:is_deleted=>0,:mg_student_id=>params[:id])
    if @vaccinations.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
      @booster_particular_record=MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>params[:id])
      @booster_particular_record.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Student Vaccination details deleted successfully"
    else
      flash[:notice]="Student Vaccination details deleted unsuccessfully"
    end
    redirect_to :back
  end


  # def immunization_booster_doses
  #   if session[:user_type]=="guardian"
  #     student_id=MgGuardian.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id],:mg_user_id=>session[:user_id]).pluck(:mg_student_id).uniq
  #     # @student=MgStudent.where(:id=>student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :id=>MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)).order(:first_name,:last_name).paginate(page: params[:page], per_page: 10)
  #     @student=MgStudent.where("id IN (?) and is_deleted=? and mg_school_id=? and id IN (?)",student_id,0,session[:current_user_school_id],MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)).order(:first_name,:last_name).paginate(page: params[:page], per_page: 10)
  #   else
  #     @student=MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :id=>MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_student_id)).order(:first_name,:last_name).paginate(page: params[:page], per_page: 10)
  #   end
  # end

  def new_immunization_booster_doses
    @time_table=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
  end
  def show_immunization_booster_doses
    @booster_doses=MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_student_id=>params[:id])
    @student=MgStudent.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:id])
    @school=MgSchool.find(session[:current_user_school_id])
    render :layout=>false
  end
  def edit_immunization_booster_doses
    @time_table=MgTimeTable.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id)
    @booster_doses=MgBoosterDoseDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_student_id=>params[:id])
    @mg_time_table_id=@booster_doses[0].try(:mg_time_table_id)
    @mg_batch_id=@booster_doses[0].try(:mg_batch_id)
    @batch =MgBatch.find_by(:id=>@booster_doses[0].try(:mg_batch_id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @batch_slect=[@batch.try(:course_batch_name),  @batch.try(:id)]
    @student=MgStudent.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>params[:id])
    @student_select=["#{@student.admission_number} #{" - "} #{@student.first_name.capitalize} #{@student.last_name.capitalize}", @student.id]
  end
  def delete_immunization_booster_doses
    @booster_doses=MgBoosterDoseDetail.where(:is_deleted=>0,:mg_student_id=>params[:id])
    if @booster_doses.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Student Booster Doses details deleted successfully"
    else
      flash[:notice]="Student Booster Doses details deleted unsuccessfully"
    end
    redirect_to :back
  end

    # Bindhu Works starts for doctor Login Creation
  def index_doctor_login
    @doctors=MgUser.where(:user_type=>"doctor",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def new_doctor
    @action='new'
    @doctor=MgUser.new
    render :layout=>false
  end

  def create_doctor_login
    array=[]
    MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(user_accounts_params)
      user_name_with_subdomain=school.subdomain + params[:doctor][:user_name]
      user.save
      array.push(user.update(:user_name=>user_name_with_subdomain))
      role=MgRole.find_by(:role_name=>"doctor")
      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        array.push(user_role.save)
      end
    end
    if array.include?(false)
      flash[:error]="Error Occured please check duplicate user name"
    else
      flash[:notice]="Successfully Created"
    end
    redirect_to :back
  end

  def edit_doctor
    @action='edit'
    @doctor=MgUser.find(params[:id])
    render :layout=>false
  end

  def update_doctor_login
    array=[]
    MgUser.transaction do
      doctor=MgUser.find_by(:id=>params[:id])
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user_name_with_domain=school.subdomain + params[:doctor][:user_name]
      array.push(doctor.update(:user_name=>user_name_with_domain,:mg_specialization_id=>params[:doctor][:mg_specialization_id]))
    end #end transaction

    if array.include?(false)
      flash[:error]="Error Occured please check duplicate user name"
    else
      flash[:notice]="Successfully Updated"
    end
    redirect_to :back
  end

  def change_doctor_password
    @doctor=MgUser.find(params[:id])
    render :layout=>false
  end

  def doctor_change_password
    user_id=params[:doctor_change_password][:user_id]
    @user=MgUser.where(:id =>user_id)
    new_password = params[:doctor_change_password][:new_password] 
    re_new_password =  params[:doctor_change_password][:re_type_password] 
    if new_password==re_new_password
      if @user
        @userMe=MgUser.find(user_id)
        @userMe.update(:password=>new_password)
        flash[:notice] = "Password changed successfully." 
      end 
    else
      flash[:error] = "Re Entered password didn't matched !"
    end
    redirect_to :back
  end

  def doctor_detail
    @doctor=MgUser.find_by(:id=>session[:user_id])
  end

  def change_password_by_doctor
    is_doctor=false
    user_id=params[:doctor_change_password][:user_id]
    @user=MgUser.where(:id =>user_id)
    user_name = MgUser.where(:id =>user_id).pluck(:user_name)
    @bool=@user.authenticate(user_name, params[:doctor_change_password][:name])
    if  @bool==nil
      flash[:notice] = "Please enter correct password !"
      is_doctor=true
    else
      new_password = params[:doctor_change_password][:new_password] 
      re_new_password =  params[:doctor_change_password][:re_type_password] 
      if new_password==re_new_password
        if @user
          @userMe=MgUser.find(user_id)
          @userMe.update(:password=>new_password)
          flash[:notice] = "Password changed successfully." 
        end 
      else
        flash[:error] = "Re Entered password didn't matched !"
      end
    end
    if is_doctor==true
      flash[:notice] = "Invalid Password..."
    else
      flash[:notice] = "Password Change Successfully..."
    end
    redirect_to :action => "doctor_detail"
  end

  def delete_doctor
    doctor=MgUser.find(params[:id])
    doctor.update(:is_deleted=>1,:updated_by=>session[:user_id])
    flash[:notice] = "Successfully Deleted"
    redirect_to :back
  end

  def doctor_index
  end

  def healthcare_admin
    @healthcare_admin=MgUser.where(:user_type=>"healthcare_admin",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def new_healthcare_admin
    @action='new'
    @healthcare_admin=MgUser.new
    render :layout=>false
  end

  def create_healthcare_admin
    array=[]
    MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(healthcare_admin_params)
      user_name_with_subdomain=school.subdomain + params[:healthcare_admin][:user_name]
      user.save
      array.push(user.update(:user_name=>user_name_with_subdomain))
      role=MgRole.find_by(:role_name=>"healthcare_admin")
      if role.id.present?
        user_role = user.mg_user_roles.build(:mg_role_id => role.id)
        user_role.save 
      end
    end
    if array.include?(true)
      flash[:notice]="Successfully Created"
    else
      flash[:error]="There is some Problem"
    end
    redirect_to :back
  end

  def edit_healthcare_admin
    @action='edit'
    @healthcare_admin=MgUser.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update_healthcare_admin
    healthcare_admin=MgUser.find_by(:id=>params[:id])
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:healthcare_admin][:user_name]
    healthcare_admin.update(:user_name=>user_name_with_domain)
    flash[:notice]="Successfully Updated"
    redirect_to :back
  end

  def delete_healthcare_admin
    healthcare_admin=MgUser.find_by(:id=>params[:id])
    healthcare_admin.update(:is_deleted=>1,:updated_by=>session[:user_id])
    redirect_to :back
  end

  def change_healthcare_admin_password
    @healthcare_admin=MgUser.find(params[:id])
    render :layout=>false
  end

  def healthcare_admin_change_password
    user_id=params[:healthcare_change_password][:user_id]
    @user=MgUser.where(:id =>user_id)
    new_password = params[:healthcare_change_password][:new_password] 
    re_new_password =  params[:healthcare_change_password][:re_type_password] 
    if new_password==re_new_password
      if @user
        @userMe=MgUser.find(user_id)
        @userMe.update(:password=>new_password)
        flash[:notice] = "Password changed successfully." 
      end 
    else
      flash[:error] = "Re Entered password didn't matched !"
    end
    redirect_to :back
  end

  def change_password_by_healthcare_admin
    is_doctor=false
    user_id=params[:healthcare_change_password][:user_id]
    @user=MgUser.where(:id =>user_id)
    user_name = MgUser.where(:id =>user_id).pluck(:user_name)
    @bool=@user.authenticate(user_name, params[:healthcare_change_password][:name])
    if  @bool==nil
      flash[:notice] = "Please enter correct password !"
      is_doctor=true
    else
      new_password = params[:healthcare_change_password][:new_password] 
      re_new_password =  params[:healthcare_change_password][:re_type_password] 
      if new_password==re_new_password
        if @user
          @userMe=MgUser.find(user_id)
          @userMe.update(:password=>new_password)
          flash[:notice] = "Password changed successfully." 
        end 
      else
        flash[:error] = "Re Entered password didn't matched !"
      end
    end
    if is_doctor==true
      flash[:error] = "Invalid Password..."
    else
      flash[:notice] = "Password Change Successfully..."
    end
    redirect_to :action => "healthcare_admin_detail"
  end

  def healthcare_admin_detail
    @healthcare_admin=MgUser.find_by(:id=>session[:user_id])
  end


  def allergy_index
    allergies=MgAllergy.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    uniq_user_allergy_id=[]
    allergy_arr=[]
    boolean=true
      allergies.each do |allergy|
        if uniq_user_allergy_id.include? allergy.mg_user_id
        else
          uniq_user_allergy_id.push(allergy.mg_user_id)
          allergy_arr.push(allergy.id)
        end
      end
    @allergies=MgAllergy.where(:id=>allergy_arr,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def allergy_new
    @action='new'
    @allergy=MgAllergy.new
  end

  def student_list
    @student_list = MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id])
    respond_to do |format|
      format.json  { render :json => @student_list }
    end
  end


  def student_list_table
    @student_list = MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id])#.where.not(:id=>stu_data)
    respond_to do |format|
      format.json  { render :json => @student_list }
    end
  end


  def employee_list
    @employee_list = MgEmployee.where(:is_deleted=>0, :mg_employee_department_id=>params[:mg_employee_department_id], :mg_school_id=>session[:current_user_school_id])
    respond_to do |format|
      format.json  { render :json => @employee_list }
    end
  end

  def employee_list_table
    @employee_list = MgEmployee.where(:is_deleted=>0, :mg_employee_department_id=>params[:mg_employee_department_id], :mg_school_id=>session[:current_user_school_id])#.where.not(:id=>emp_data)
    respond_to do |format|
      format.json  { render :json => @employee_list }
    end
  end

  def allergy_record
    if params[:mg_student_id].present?
      @allergy_record=MgAllergy.where(:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    else
      @allergy_record=MgAllergy.where(:mg_employee_id=>params[:mg_employee_id],:mg_employee_department_id=>params[:mg_employee_department_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end
    render :layout=>false
  end

  def allergy_create
    begin
      MgAllergy.transaction do
        if params[:allergy][:allergy_for]=='student'
          record_id=params[:record_id]
          student_user_id=MgStudent.find_by(:id=>params[:allergy][:mg_student_id])
          @myallergy= params[:allergy][:mg_batch_id]    

          if record_id.present?
            record_id.each do |record_id|
              @allergy_obj = MgAllergy.find_by(:id=>record_id,:mg_school_id=>session[:current_user_school_id])
              @allergy_obj.update(:is_deleted=>1)
            end
          end

          if params[:name].present?
            params[:name].each do |key,val|
              if record_id.include?(key)
                @allergy_obj= MgAllergy.find_by(:id=>key,:mg_school_id=>session[:current_user_school_id])
                @allergy_obj.update(:mg_school_id=>session[:current_user_school_id],:name=>val,:description=>params[:description][key],:status=>params[:status][key],:medication_detail=>params[:medication_detail][key],:is_deleted=>0,:updated_by=>session[:user_id])
              end
            end
          end

          if params[:newname].present?
            params[:newname].each do |key,val|
              new_allergy=MgAllergy.new()
              new_allergy.name=val
              new_allergy.description=params[:newdescription][key]
              new_allergy.status=params[:newstatus][key]
              new_allergy.medication_detail=params[:newmedication_detail][key]
              new_allergy.mg_batch_id=params[:allergy][:mg_batch_id]
              new_allergy.mg_student_id=params[:allergy][:mg_student_id]
              new_allergy.allergy_for=params[:allergy][:allergy_for]
              new_allergy.mg_user_id=student_user_id.try(:mg_user_id)
              new_allergy.is_deleted=0
              new_allergy.updated_by=session[:user_id]
              new_allergy.created_by=session[:user_id]
              new_allergy.mg_school_id=session[:current_user_school_id]
              new_allergy.save
            end
          end
        else
          record_id=params[:record_id]
          @myallergy= params[:allergy][:mg_employee_department_id]    
          employee_user_id=MgEmployee.find_by(:id=>params[:allergy][:mg_employee_id])

          if record_id.present?
            record_id.each do |record_id|
              @allergy_obj = MgAllergy.find_by(:id=>record_id,:mg_school_id=>session[:current_user_school_id])
              @allergy_obj.update(:is_deleted=>1)
            end
          end
          if params[:name].present?
            params[:name].each do |key,val|
              if record_id.include?(key)
                @allergy_obj= MgAllergy.find_by(:id=>key,:mg_school_id=>session[:current_user_school_id])
                @allergy_obj.update(:mg_school_id=>session[:current_user_school_id],:name=>val,:description=>params[:description][key],:status=>params[:status][key],:medication_detail=>params[:medication_detail][key],:is_deleted=>0,:updated_by=>session[:user_id])
              end
            end
          end

          if params[:newname].present?
            params[:newname].each do |key,val|
              new_allergy=MgAllergy.new()
              new_allergy.name=val
              new_allergy.description=params[:newdescription][key.to_s]
              new_allergy.status=params[:newstatus][key.to_s]
              new_allergy.medication_detail=params[:newmedication_detail][key.to_s]
              new_allergy.mg_employee_department_id=params[:allergy][:mg_employee_department_id]
              new_allergy.mg_employee_id=params[:allergy][:mg_employee_id]
              new_allergy.allergy_for=params[:allergy][:allergy_for]
              new_allergy.mg_user_id=employee_user_id.try(:mg_user_id)
              new_allergy.is_deleted=0
              new_allergy.updated_by=session[:user_id]
              new_allergy.created_by=session[:user_id]
              new_allergy.mg_school_id=session[:current_user_school_id]
              new_allergy.save
            end
          end
        end
      end#end transaction
      flash[:notice]="Successfully Created"
    rescue Exception => e
      flash[:error]="Error Occured"
    end
    redirect_to :action=>"allergy_new", :allergy_for=>"#{params[:allergy][:allergy_for]}",:batch_Id=>"#{params[:allergy][:mg_batch_id]}",:dept_Id=>"#{params[:allergy][:mg_employee_department_id]}",:custome_url=>"custome_url"
  end

  def allergy_edit
    @action='edit'
    @allergy=MgAllergy.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def allergy_update
    begin
      MgAllergy.transaction do
        if params[:allergy][:allergy_for]=='student'
          record_id=params[:record_id]
          student_user_id=MgStudent.find_by(:id=>params[:mg_student_student_id])

          if record_id.present?
            record_id.each do |record_id|
              @allergy_obj = MgAllergy.find_by(:id=>record_id,:mg_school_id=>session[:current_user_school_id])
              @allergy_obj.update(:is_deleted=>1)
            end
          end

          if params[:name].present?
            params[:name].each do |key,val|
              if record_id.include?(key)
                @allergy_obj= MgAllergy.find_by(:id=>key,:mg_school_id=>session[:current_user_school_id])
                @allergy_obj.update(:mg_school_id=>session[:current_user_school_id],:name=>val,:description=>params[:description][key],:status=>params[:status][key],:medication_detail=>params[:medication_detail][key],:is_deleted=>0,:updated_by=>session[:user_id])
              end
            end
          end
          if params[:newname].present?
            params[:newname].each do |key,val|
              new_allergy=MgAllergy.new()
              new_allergy.name=val
              new_allergy.description=params[:newdescription][key.to_s]
              new_allergy.status=params[:newstatus][key.to_s]
              new_allergy.medication_detail=params[:newmedication_detail][key.to_s]
              new_allergy.mg_batch_id=params[:mg_student_batch_id]
              new_allergy.mg_student_id=params[:mg_student_student_id]
              new_allergy.allergy_for=params[:allergy][:allergy_for]
              new_allergy.mg_user_id=student_user_id.try(:mg_user_id)
              new_allergy.is_deleted=0
              new_allergy.updated_by=session[:user_id]
              new_allergy.created_by=session[:user_id]
              new_allergy.mg_school_id=session[:current_user_school_id]
              new_allergy.save
            end
          end
        else
          record_id=params[:record_id]
          employee_user_id=MgEmployee.find_by(:id=>params[:mg_employee_emp_id])

          if record_id.present?
            record_id.each do |record_id|
              @allergy_obj = MgAllergy.find_by(:id=>record_id,:mg_school_id=>session[:current_user_school_id])
              @allergy_obj.update(:is_deleted=>1)
            end
          end
          if params[:name].present?
            params[:name].each do |key,val|
              if record_id.include?(key)
                @allergy_obj= MgAllergy.find_by(:id=>key,:mg_school_id=>session[:current_user_school_id])
                @allergy_obj.update(:mg_school_id=>session[:current_user_school_id],:name=>val,:description=>params[:description][key],:status=>params[:status][key],:medication_detail=>params[:medication_detail][key],:is_deleted=>0,:updated_by=>session[:user_id])
              end
            end
          end

          if params[:newname].present?
            params[:newname].each do |key,val|
              new_allergy=MgAllergy.new()
              new_allergy.name=val
              new_allergy.description=params[:newdescription][key.to_s]
              new_allergy.status=params[:newstatus][key.to_s]
              new_allergy.medication_detail=params[:newmedication_detail][key.to_s]
              new_allergy.mg_employee_department_id=params[:mg_employee_emp_department_id]
              new_allergy.mg_employee_id=params[:mg_employee_emp_id]
              new_allergy.allergy_for=params[:allergy][:allergy_for]
              new_allergy.mg_user_id=employee_user_id.try(:mg_user_id)
              new_allergy.is_deleted=0
              new_allergy.updated_by=session[:user_id]
              new_allergy.created_by=session[:user_id]
              new_allergy.mg_school_id=session[:current_user_school_id]
              new_allergy.save
            end
          end
        end
      end #transaction end
      flash[:notice]="Successfully Updated"
    rescue Exception => e
      flash[:error]="Error Occured"
    end
    redirect_to :action=>"allergy_index"
  end

  def allergy_show
    @allergy=MgAllergy.find(params[:id])
    @allergies=MgAllergy.where(:mg_user_id=>@allergy.try(:mg_user_id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def allergy_delete
    allergies=MgAllergy.find_by(:id=>params[:id])
    allergy=MgAllergy.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_user_id=>allergies.mg_user_id)
    temp=0
    allergy.each do |delete_data|
      delete_data.update(:is_deleted=>1)
      temp=1
    end
    if temp==1
      flash[:notice]="Deleted successfully"
      redirect_to :action=>"allergy_index"
    else
      flash[:error]="Error Occured"
      redirect_to :action=>"allergy_index"
    end
  end

  def bed_detail
    @bed = MgBedDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def new_bed_detail
    @action='new'
    @bed_detail = MgBedDetail.new
    render :layout=>false
  end

  def create_bed_detail
    bed= MgBedDetail.new(bed_detail_params)
    if bed.save
      flash[:notice] = "Successfully Created"
    else
      flash[:error] = "This Room Nnumber is already Created"
    end
    redirect_to :action=>'bed_detail'
  end

  def show_bed_detail
    @bed = MgBedDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def edit_bed_detail
    @action='edit'
    @bed_detail = MgBedDetail.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update_bed_detail
    bed = MgBedDetail.find_by(:id=>params[:id])
    if bed.update(bed_detail_params)
      flash[:notice] = "Successfully Updated"
    else
      flash[:error] = "This Room Nnumber is already Created"
    end
    redirect_to :action=>'bed_detail'
  end

  def delete_bed_detail
    bed = MgBedDetail.find_by(:id=>params[:id])
    if bed.update(:is_deleted=>1,:updated_by=>session[:user_id])
      assign_bed_details=MgBedAssignment.where(:mg_bed_details_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      assign_bed_details.each do |assign_bed|
        assign_bed.update(:is_deleted=>1,:updated_by=>session[:user_id])
      end
      flash[:notice] = "Successfully Deleted"
    else
      flash[:error] = "There is Some Problem"
    end
    redirect_to :action=>'bed_detail'
  end

  def assign_bed
    if session[:user_type]=='doctor'
      @bed_assign_detail = MgBedAssignment.where(:mg_doctor_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("status ASC").paginate(page: params[:page], per_page: 10)
    else
      @bed_assign_detail = MgBedAssignment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("status ASC").paginate(page: params[:page], per_page: 10)
    end
  end

  def new_assign_bed
    @action='new'
    @bed_assign_detail = MgBedAssignment.new
  end

  def bed_assigned_record
    @user_data=MgUser.find_by(:user_name=>params[:user_id])
    if @user_data.present?
      if @user_data.user_type=="student"
        @student_data = MgStudent.find_by(:admission_number=>params[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      elsif (@user_data.user_type=="employee" || @user_data.user_type=="principal") || @user_data.user_type=="admin"
        @employee_data=MgEmployee.find_by(:employee_number=>params[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      end
      render :layout=>false
    else
      @result='no_data'
      respond_to do |format|
        format.json  { render :json => @result.to_json }
      end
    end
  end

  def bed_availibility
    # test_obj=false
    # @timeformat = MgSchool.find(session[:current_user_school_id])
    # admitted_date = Date.strptime(params[:admitted_date],@timeformat.date_format)
    # discharge_date = Date.strptime(params[:discharge_date],@timeformat.date_format)
    # send_param=MgBedAssignment.myprm(admitted_date,discharge_date)

    # if params[:edit_action_url]=="edit_assign_bed"
    #   MgBedAssignment.transaction do
    #     @bed_assign_detail = MgBedAssignment.find_by(:id=>params[:edit_action_id])
    #     test_obj = @bed_assign_detail.update(:admitted_date=>admitted_date,:discharge_date=>discharge_date,:admitted_time=>params[:admitted_time],:discharge_time=>params[:discharge_time],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_bed_details_id=>params[:edit_action_bed_id])
    #     raise ActiveRecord::Rollback
    #   end
    # else
    #   MgBedAssignment.transaction do
    #     obj=MgBedAssignment.new
    #     obj.admitted_date=admitted_date
    #     obj.discharge_date=discharge_date
    #     obj.admitted_time=params[:admitted_time]
    #     obj.discharge_time=params[:discharge_time]
    #     obj.is_deleted=0
    #     obj.mg_school_id=session[:current_user_school_id]
    #     obj.mg_bed_details_id=params[:bed_id]
    #     test_obj=obj.save
    #     raise ActiveRecord::Rollback
    #   end
    # end

    result = MgBedAssignment.where(:mg_bed_details_id=>params[:bed_details_id],:status=>"occupied",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    if result.present?
      @result="not present"
    else
      @result="present"
    end
    respond_to do |format|
      format.json  { render :json => @result.to_json }
    end

  end

  def create_assign_bed
    user_obj = MgUser.find_by(:user_name=>params[:bed_assign_detail][:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    if user_obj.user_type=='student'
      student_obj=MgStudent.find_by(:admission_number=>params[:bed_assign_detail][:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      guardian_obj=MgGuardian.find_by(:mg_student_id=>student_obj.try(:id),:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      mg_user_id=guardian_obj.try(:mg_user_id)
      msg = "#{student_obj.admission_number}#{"-"}#{}{student_obj.first_name.capitalize} #{student_obj.last_name.capitalize} is suffering some Problem"
    else
      mg_user_id=user_obj.id
      mg_emp_obj=MgEmployee.find_by(:employee_number=>params[:bed_assign_detail][:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      msg = "#{mg_emp_obj.first_name.capitalize} #{mg_emp_obj.last_name.capitalize} is suffering some Problem"
    end

    array=[]
    MgBedAssignment.transaction do
      bed_assign_detail= MgBedAssignment.new(bed_assign_details_params)

      @timeformat = MgSchool.find(session[:current_user_school_id])
      admitted_date = Date.strptime(params[:bed_assign_detail][:admitted_date],@timeformat.date_format)
      # discharge_date = Date.strptime(params[:bed_assign_detail][:discharge_date],@timeformat.date_format)
      #discharge_date = Date.strptime(params[:bed_assign_detail][:discharge_date],SchoolDateFormat.format(session[:current_user_school_id]))
      array.push(bed_assign_detail.save)
      if bed_assign_detail.save
        array.push(bed_assign_detail.update(:admitted_date=>admitted_date,:module_type=>"healthcare"))
      end
      if array.include?(false) 
        raise ActiveRecord::Rollback 
      else
        if mg_user_id.present?
          send_email_create(mg_user_id,msg)
        end
      end 
    end

    if array.include?(false)
      flash[:error] = "There is Some Problem"
    else
      flash[:notice] = "Successfully Created"
    end
    redirect_to :action=>'assign_bed'
  end

  def show_assign_bed
    @bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @date_format = MgSchool.find_by(:id=>session[:current_user_school_id]).date_format
    
    render :layout=>false
  end

  def edit_assign_bed
    @action='edit'
    @bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id])
  end

  def update_assign_bed

    array=[]
    MgBedAssignment.transaction do
      bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id])

      @timeformat = MgSchool.find(session[:current_user_school_id])
      array.push(bed_assign_detail.update(update_bed_assign_details_params))

      if session[:user_type]=="doctor"
        array.push(bed_assign_detail.update(:comments=>params[:bed_assign_detail][:comments]))
      else
        if params[:bed_assign_detail][:status]=="unoccupied"
          if params[:bed_assign_detail][:admitted_date].present? && params[:bed_assign_detail][:discharge_date]
            admitted_date = Date.strptime(params[:bed_assign_detail][:admitted_date],@timeformat.date_format)
            discharge_date = Date.strptime(params[:bed_assign_detail][:discharge_date],@timeformat.date_format)
            array.push(bed_assign_detail.update(:admitted_date=>admitted_date,:discharge_date=>discharge_date))
          end
        else
          admitted_date = Date.strptime(params[:bed_assign_detail][:admitted_date],@timeformat.date_format)
          array.push(bed_assign_detail.update(:admitted_date=>admitted_date,:discharge_date=>nil,:discharge_time=>nil))
        end
      end

      if array.include?(false)
        raise ActiveRecord::Rollback 
      end
    end

    if array.include?(false)
      flash[:error] = "There is Some Problem"
    else
      flash[:notice] = "Successfully Updated"
    end
    redirect_to :action=>'assign_bed'
  end
 
  def delete_assign_bed
    bed_assign_detail = MgBedAssignment.find_by(:id=>params[:id])
    if bed_assign_detail.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice] = "Successfully Deleted"
    else
      flash[:error] = "There is Some Problem"
    end
    redirect_to :action=>'assign_bed'
  end

  def check_up_schedule
    @checkup_schedule = MgCheckUpSchedule.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order('date ASC').paginate(page: params[:page], per_page: 10)
  end

  def new_check_up_schedule
    @action='new'
    @checkup_schedule = MgCheckUpSchedule.new
  end

  def create_check_up_schedule

    @timeformat = MgSchool.find(session[:current_user_school_id])
    start_date = Date.strptime(params[:checkup_schedule][:date],@timeformat.date_format)
    send_param=MgCheckUpSchedule.myprm(start_date)
    array=[]

    MgCheckUpSchedule.transaction do
      checkup_schedule= MgCheckUpSchedule.new(checkup_schedule_params)

      @timeformat = MgSchool.find(session[:current_user_school_id])
      date = Date.strptime(params[:checkup_schedule][:date],@timeformat.date_format)
      checkup_schedule.save
      if checkup_schedule.save
        checkup_schedule.update(:date=>date)
        if params[:checkup_schedule][:checkup_for]=='employee'
          employee_department_id = params[:mg_employee_department_id]
          employee_department_id.each do |id|
            @schedule_record = checkup_schedule.mg_check_up_schedule_records.new(:mg_check_up_type_id=>params[:checkup_schedule][:mg_check_up_type_id],:mg_employee_department_id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
            array.push(@schedule_record.save)
          end
        elsif params[:checkup_schedule][:checkup_for]=='student'
          batch_id = params[:mg_batch_id]
          batch_id.each do |id|
            @schedule_record = checkup_schedule.mg_check_up_schedule_records.new(:mg_check_up_type_id=>params[:checkup_schedule][:mg_check_up_type_id],:mg_batch_id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
            array.push(@schedule_record.save)
          end
        end
      end
      if !array.include?(true) 
        raise ActiveRecord::Rollback
      else
        checkup_type=MgCheckupType.find_by(:id=>params[:checkup_schedule][:mg_check_up_type_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        time= params[:checkup_schedule][:start_time]
        schedule_date=params[:checkup_schedule][:date]
        msg="Checkup Schedule for #{checkup_type.try(:name).capitalize} has been created on Date #{schedule_date} and Time #{time}"
        if params[:mg_batch_id].present?
          checkup_for=params[:checkup_schedule][:checkup_for]
          send_schedule_email(params[:mg_batch_id],msg,checkup_for) 
        else
          checkup_for=params[:checkup_schedule][:checkup_for]
          send_schedule_email(params[:mg_employee_department_id],msg,checkup_for) 
        end
      end 
    end

    if array.include?(true)
      flash[:notice] = "Successfully Created "
    else
      flash[:error] = "Created schedule Doctor is not free please change schedule"
    end
    redirect_to :action=>'check_up_schedule'
  end

  def show_check_up_schedule
    @checkup_schedule=MgCheckUpSchedule.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    @doctor=MgUser.find_by(:id=>@checkup_schedule.mg_doctor_id)
    render :layout=>false
  end

  def edit_check_up_schedule
    @action='edit'
    @checkup_schedule=MgCheckUpSchedule.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    if @checkup_schedule.checkup_for=='student'
      @schedule_record = @checkup_schedule.mg_check_up_schedule_records.where(:is_deleted=>0).pluck(:mg_batch_id)
    else
      @schedule_record = @checkup_schedule.mg_check_up_schedule_records.where(:is_deleted=>0).pluck(:mg_employee_department_id)
    end
  end

  def update_check_up_schedule
    @timeformat = MgSchool.find(session[:current_user_school_id])
    start_date = Date.strptime(params[:checkup_schedule][:date],@timeformat.date_format)
    send_param=MgCheckUpSchedule.myprm(start_date)
    array=[]
    MgCheckUpSchedule.transaction do
      checkup_schedule=MgCheckUpSchedule.find_by(:id=>params[:id])
      @timeformat = MgSchool.find(session[:current_user_school_id])
      date = Date.strptime(params[:checkup_schedule][:date],@timeformat.date_format)
      checkup_schedule.update(checkup_schedule_params)
      if checkup_schedule.update(:date=>date)
          if params[:checkup_schedule][:checkup_for]=='employee'
            checkup_schedule.mg_check_up_schedule_records.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
            employee_department_id = params[:mg_employee_department_id]
            employee_department_id.each do |id|
              @schedule_record = checkup_schedule.mg_check_up_schedule_records.new(:mg_check_up_type_id=>params[:checkup_schedule][:mg_check_up_type_id],:mg_employee_department_id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
              array.push(@schedule_record.save)
            end
          elsif params[:checkup_schedule][:checkup_for]=='student'
            checkup_schedule.mg_check_up_schedule_records.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
            batch_id = params[:mg_batch_id]

            batch_id.each do |id|
              @schedule_record = checkup_schedule.mg_check_up_schedule_records.new(:mg_check_up_type_id=>params[:checkup_schedule][:mg_check_up_type_id],:mg_batch_id=>id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
              array.push(@schedule_record.save)
            end
          end
        end
      if !array.include?(true) 
        raise ActiveRecord::Rollback 
      end 
    end

    if array.include?(true)
      flash[:notice] = "Successfully Updated"
    else
      flash[:error] = "Created schedule Doctor is not free please change schedule"
    end
    redirect_to :action=>'check_up_schedule'
  end

  def delete_check_up_schedule
     checkup_schedule=MgCheckUpSchedule.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
     checkup_schedule_record=MgCheckUpScheduleRecord.where(:mg_check_up_schedule_id=>params[:id], :mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
     mg_health_test=MgHealthTest.where(:mg_check_up_schedule_id=>params[:id], :mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    if checkup_schedule.update(:is_deleted=>1,:updated_by=>session[:user_id])
      if checkup_schedule_record.present?
        checkup_schedule_record.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
        if mg_health_test.present?
          mg_health_test.update_all(:is_deleted=>1,:updated_by=>session[:user_id])
        end
      end
      flash[:notice]="successfully Deleted"
    else
      flash[:error]="There is Some Problem"
    end
    redirect_to :action=>'check_up_schedule'
  end

  def health_test
    @health_test = MgCheckUpSchedule.where(:mg_doctor_id=>session[:user_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def manage_health_test
    @health_test = MgCheckUpSchedule.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    if @health_test.present? && @health_test.checkup_for=='student'
      @batch_id = MgCheckUpScheduleRecord.where(:mg_check_up_schedule_id=>params[:id],:is_deleted=>0).pluck(:mg_batch_id)
    elsif @health_test.present? && @health_test.checkup_for=='employee'
      @emp_department_id = MgCheckUpScheduleRecord.where(:mg_check_up_schedule_id=>params[:id],:is_deleted=>0).pluck(:mg_employee_department_id)
    end
  end

  def student_employe_list
    if params[:batch_id].present?
      @student_emp_obj = MgStudent.where(:is_deleted=>0,:mg_batch_id=>params[:batch_id],:mg_school_id=>session[:current_user_school_id])#.pluck(:first_name,:id)
      @student_emp_obj.map{ |name| name.first_name=name.admission_number.to_s+' - '+name.first_name.capitalize.to_s+' '.to_s+name.last_name.capitalize.to_s}#.reduce(:merge)
    else
      @student_emp_obj = MgEmployee.where(:is_deleted=>0,:mg_employee_department_id=>params[:emp_department_id],:mg_school_id=>session[:current_user_school_id])#.pluck(:first_name,:id)
      @student_emp_obj.map{ |name| name.first_name=name.employee_number.to_s+' - '+name.first_name.capitalize.to_s+' '.to_s+name.last_name.capitalize.to_s}
    end
    render :layout=>false
  end

  def section_form
    if params[:mg_batch_id].present?
      @checkup_particular = MgCheckupParticular.where("mg_checkup_type_id=? and is_deleted=? and mg_school_id=? and (applicable=? or applicable=?) ",params[:check_type_id],0,session[:current_user_school_id],'student','both') 
      @health_test_record_history=MgHealthTest.where('mg_check_up_type_id=? and mg_student_id=? and mg_batch_id=? and  is_deleted=? and mg_school_id=? and  mg_check_up_schedule_id NOT IN (?)',
        params[:check_type_id],params[:mg_student_id],params[:mg_batch_id],0,session[:current_user_school_id],params[:mg_check_up_schedule_id]).order('mg_check_up_schedule_id ASC').uniq.pluck(:mg_check_up_schedule_id).last(2)
    else
      @checkup_particular = MgCheckupParticular.where("mg_checkup_type_id=? and is_deleted=? and mg_school_id=? and (applicable=? or applicable=?) ",params[:check_type_id],0,session[:current_user_school_id],'employee','both') 
      @health_test_record_history=MgHealthTest.where('mg_check_up_type_id=? and mg_employee_id=? and mg_employee_department_id=? and  is_deleted=? and mg_school_id=? and  mg_check_up_schedule_id NOT IN (?)',
        params[:check_type_id],params[:mg_employee_id],params[:mg_employee_department_id],0,session[:current_user_school_id],params[:mg_check_up_schedule_id]).order('mg_check_up_schedule_id ASC').uniq.pluck(:mg_check_up_schedule_id).last(2)
    end
    render :layout=>false
  end

  def health_test_history
    if params[:mg_student_id].present?
       @health_test_history=MgHealthTest.where('mg_check_up_type_id=? and mg_student_id=? and mg_batch_id=? and  is_deleted=? and mg_school_id=? and  mg_check_up_schedule_id NOT IN (?)',
        params[:check_type_id],params[:mg_student_id],params[:mg_batch_id],0,session[:current_user_school_id],params[:mg_check_up_schedule_id]).order('mg_check_up_schedule_id DESC').uniq.pluck(:mg_check_up_schedule_id)
      @checkup_particular = MgCheckupParticular.where("mg_checkup_type_id=? and is_deleted=? and mg_school_id=? and (applicable=? or applicable=?) ",params[:check_type_id],0,session[:current_user_school_id],'student','both') 
    else
      @health_test_history=MgHealthTest.where('mg_check_up_type_id=? and mg_employee_id=? and mg_employee_department_id=? and  is_deleted=? and mg_school_id=? and  mg_check_up_schedule_id NOT IN (?)',
        params[:check_type_id],params[:mg_employee_id],params[:mg_employee_department_id],0,session[:current_user_school_id],params[:mg_check_up_schedule_id]).order('mg_check_up_schedule_id DESC').uniq.pluck(:mg_check_up_schedule_id)
      @checkup_particular = MgCheckupParticular.where("mg_checkup_type_id=? and is_deleted=? and mg_school_id=? and (applicable=? or applicable=?) ",params[:check_type_id],0,session[:current_user_school_id],'employee','both') 
    end
    render :layout=>false
  end
  
  def create_health_test
    array=[]
    MgHealthTest.transaction do
      @user_type = MgCheckUpSchedule.find_by(:id=>params[:health_test][:checkup_for],:is_deleted=>0)
      @timeformat = MgSchool.find(session[:current_user_school_id])
      date = Date.strptime(params[:health_test][:date],@timeformat.date_format)
      particular_id_array = params[:mg_checkup_particular_id]
      
      particular_id_array.each_with_index do |particular_ids,index|
        @healt_test_record = MgHealthTest.where("mg_checkup_particular_id=? and mg_check_up_type_id=? and mg_check_up_schedule_id=? 
          and is_deleted=? and ((mg_batch_id=? and mg_student_id=?) OR
           (mg_employee_department_id=? and mg_employee_id=?))",particular_ids,params[:health_test][:mg_check_up_type_id],
           params[:mg_check_up_schedule_id],0,params[:mg_batch_id],params[:mg_student_id],params[:mg_employee_department_id],params[:mg_employee_id])
        if @healt_test_record.present?
          array.push(@healt_test_record[0].update(:result=>params[:result][index],:recommendation=>params[:recommendation][index], :updated_by=>session[:user_id]))
        else
          health_test = MgHealthTest.new(:mg_check_up_schedule_id=>params[:mg_check_up_schedule_id],:user_type=>@user_type.try(:checkup_for),:mg_check_up_type_id=>params[:health_test][:mg_check_up_type_id],
          :date=>date,:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:mg_checkup_particular_id=>particular_ids,
          :mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:result=>params[:result][index],
          :recommendation=>params[:recommendation][index],:is_deleted=>params[:health_test][:is_deleted],:created_by=>params[:health_test][:created_by],
          :updated_by=>params[:health_test][:updated_by],:mg_school_id=>params[:health_test][:mg_school_id])
          array.push(health_test.save)
        end
      end
      if array.include?(false) 
        raise ActiveRecord::Rollback 
      end 
    end
    if array.include?(false) 
      flash[:error]="There is some Problem"
    else
      flash[:notice]="Successfully Updated"
    end 
    redirect_to :action=>'manage_health_test',:id=>params[:mg_check_up_schedule_id],:batch_id=>params[:mg_batch_id],:emp_deparment_id=>params[:mg_employee_department_id]
  end

  def edit_health_test
    @health_test = MgCheckUpSchedule.find_by(:id=>params[:checkup_schedule_id],:mg_school_id=>session[:current_user_school_id])
    if @health_test.present? && @health_test.checkup_for=='student'
      @batch_id = MgCheckUpScheduleRecord.where(:mg_check_up_schedule_id=>params[:checkup_schedule_id],:is_deleted=>0).pluck(:mg_batch_id)
      @mg_health_test_obj = MgHealthTest.where(:mg_student_id=>params[:id],:is_deleted=>0)
    elsif @health_test.present? && @health_test.checkup_for=='employee'
      @emp_department_id = MgCheckUpScheduleRecord.where(:mg_check_up_schedule_id=>params[:checkup_schedule_id],:is_deleted=>0).pluck(:mg_employee_department_id)
      @mg_health_test_obj = MgHealthTest.where(:mg_employee_id=>params[:id],:is_deleted=>0)
    end
  end

  def update_health_test
    array=[]
    MgHealthTest.transaction do
      @timeformat = MgSchool.find(session[:current_user_school_id])
      date = Date.strptime(params[:health_test][:date],@timeformat.date_format)
      particular_id_array = params[:mg_checkup_particular_id]
      particular_id_array.each_with_index do |particular_ids,index|
        @healt_test_record = MgHealthTest.where("mg_checkup_particular_id=? and mg_check_up_type_id=? and mg_check_up_schedule_id=? 
          and is_deleted=? and ((mg_batch_id=? and mg_student_id=?) OR (mg_employee_department_id=? and mg_employee_id=?))",particular_ids,params[:health_test][:mg_check_up_type_id],
           params[:mg_check_up_schedule_id],0,params[:health_test][:mg_batch_id],params[:health_test][:mg_student_id],params[:health_test][:mg_employee_department_id],params[:health_test][:mg_employee_id])

        if @healt_test_record.present?
          array.push(@healt_test_record[0].update(:result=>params[:result][index],:recommendation=>params[:recommendation][index], :updated_by=>session[:user_id]))
        end
      end
      if array.include?(false) 
        raise ActiveRecord::Rollback 
      end 
    end
    if array.include?(false) 
      flash[:error]="There is some Problem"
    else
      flash[:notice]="Successfully Updated"
    end 
    redirect_to :action=>'show_health_test',:id=>params[:mg_check_up_schedule_id]
  end

  def show_health_test
    @health_test = MgHealthTest.where(:mg_check_up_schedule_id=>params[:id],:is_deleted=>0)
    @user_type = MgCheckUpSchedule.find_by(:id=>params[:id],:is_deleted=>0)
  end

  def health_test_from_section
    if params[:emp_result].present?
      @health_test = MgHealthTest.where(:mg_check_up_schedule_id=>params[:mg_checkup_schedule_id],:mg_employee_id=>params[:id],:is_deleted=>0)
    else
      @health_test = MgHealthTest.where(:mg_check_up_schedule_id=>params[:mg_checkup_schedule_id],:mg_student_id=>params[:id],:is_deleted=>0)
    end
    render :layout=>false
  end

  def delete_health_test
    if params[:delete_by]=='delete_by_student'
      health_test_record = MgHealthTest.where(:mg_student_id=>params[:id],:is_deleted=>0)
      health_test_record.each do |obj|
        obj.update(:is_deleted=>1,:updated_by=>session[:user_id])
      end
    else
      health_test_record = MgHealthTest.where(:mg_employee_id=>params[:id],:is_deleted=>0)
      health_test_record.each do |obj|
        obj.update(:is_deleted=>1,:updated_by=>session[:user_id])
      end
    end
    redirect_to :back
  end
  
  def generate_report
  end

  def health_card_record
    array=[]
    if params[:student_record].present?
      @checkup_type = MgHealthTest.where(:is_deleted=>0,:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id]).pluck("DISTINCT mg_check_up_type_id")
      @vaccination_detail = MgVaccinationDetail.where(:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @allergy = MgAllergy.where(:is_deleted=>0,:mg_student_id=>params[:mg_student_id], :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id])
      @booster_dose = MgBoosterDoseDetail.where(:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    else
      @checkup_type = MgHealthTest.where(:is_deleted=>0,:mg_employee_id=>params[:mg_employee_id],:mg_employee_department_id=>params[:mg_employee_department_id]).pluck("DISTINCT mg_check_up_type_id")
      @allergy = MgAllergy.where(:is_deleted=>0,:mg_employee_department_id=>params[:mg_employee_department_id], :mg_employee_id=>params[:mg_employee_id], :mg_school_id=>session[:current_user_school_id])
    end
    render :layout=>false
  end

  def healh_card_pdf
    array=[]
    @school=MgSchool.find(session[:current_user_school_id])
    @school_logo=@school.logo.url(:medium,:timestamp=>false)
    @date_format = MgSchool.find_by(:id=>session[:current_user_school_id]).date_format

    if params[:mg_employee_id] ==''
      @student_id = params[:mg_student_id]
      @batch_id = params[:mg_batch_id]
      health_record_obj = MgHealthTest.where(:is_deleted=>0,:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id]).pluck("DISTINCT mg_check_up_type_id")
      @vaccination_detail = MgVaccinationDetail.where(:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.pluck(:mg_vaccination_id)
      @allergy = MgAllergy.where(:is_deleted=>0,:mg_student_id=>params[:mg_student_id], :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id])
      @booster_dose = MgBoosterDoseDetail.where(:mg_student_id=>params[:mg_student_id],:mg_batch_id=>params[:mg_batch_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#.pluck(:mg_booster_dose_id)
    else
      @employee_id = params[:mg_employee_id]
      @employee_department_id = params[:mg_employee_department_id]
      @allergy = MgAllergy.where(:is_deleted=>0,:mg_employee_department_id=>params[:mg_employee_department_id], :mg_employee_id=>params[:mg_employee_id], :mg_school_id=>session[:current_user_school_id])
      health_record_obj = MgHealthTest.where(:is_deleted=>0,:mg_employee_id=>params[:mg_employee_id],:mg_employee_department_id=>params[:mg_employee_department_id]).pluck("DISTINCT mg_check_up_type_id")#.map(&:mg_checkup_particular_id)#.uniq.pluck(:mg_checkup_particular_id)
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = HealthCard.new(@school,@date_format,@school_logo,@student_id,@batch_id,@employee_id,@employee_department_id,health_record_obj,@vaccination_detail,@allergy,@booster_dose)
        send_data pdf.render, filename: 
        "health_card#{DateTime.now.strftime(@date_format)}.pdf",
        type: "application/pdf", :disposition => 'inline'
      end
    end
end
                                    
  def send_email_create(user, msg)
    begin
      @email_from = MgEmail.where(:mg_user_id => session[:user_id])
      @message = Message.new
      @message.subject =  "Health Problem"
      @message.description =msg
      @email_to = MgEmail.where(:mg_user_id => user)
      
      if @email_to.present?
        @message.to_user_id = @email_to[0][:mg_email_id ]
        if @email_from.present?
          @message.from_user_id = @email_from[0][:mg_email_id ]
        else
          @message.from_user_id = "abc@mindcomgroup.com"
        end
        server_response = NotificationMailer.send_mail(@message).deliver!
        
        db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                  :to_user_id => user.to_i,
                  :subject => @message.subject,
                  :description => @message.description,
                  :is_deleted => 0,
                  :from_user_id =>session[:user_id],
                  :status => 0)
        @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                    :email_addrs_to => @message.to_user_id,
                              :mg_school_id => session[:current_user_school_id] ,
                                    :email_addrs_by => @message.from_user_id,
                                    :email_subject => 'test',
                                   :email_server_description => server_description(server_response.status) )
      else
        puts "Email id is not present"
      end
      return @notice="Mail Sent Successfully."
    rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      puts e
      return @notice="Email Id is not valid."
    rescue ArgumentError => e
      puts "inside Exception in principal"
      puts e
      return @notice="Email to address is not present."
    rescue Exception => e
      puts e
      puts "inside Exception in principal"
      return @notice="Error while sending email,Please contact admin."
    end
  end

  def send_schedule_email(ids, msg,checkup_for)
    begin
      @message = Message.new
      @message.subject =  "Checkup Schedule"
      @message.description =msg

      if checkup_for=="student"
        mg_batch_id=ids
        student_user_id=MgStudent.where("is_deleted=? and mg_school_id=? and mg_batch_id IN (?)",0,session[:current_user_school_id],mg_batch_id).pluck(:mg_user_id)
        student_id=MgStudent.where("is_deleted=? and mg_school_id=? and mg_batch_id IN (?)",0,session[:current_user_school_id],mg_batch_id).pluck(:id)
        guardian_user_id=MgGuardian.where("is_deleted=? and mg_school_id=? and mg_student_id IN (?)",0,session[:current_user_school_id],student_id).pluck(:mg_user_id)
        mg_user_id = student_user_id+guardian_user_id
      else
        mg_emp_department_id=ids
        mg_user_id=MgEmployee.where("is_deleted=? and mg_school_id=? and mg_employee_department_id IN (?)",0,session[:current_user_school_id],mg_emp_department_id).pluck(:mg_user_id)
      end
      puts "user_id for sending emaillllllllll"
      puts mg_user_id.inspect
      puts "user_id for sending emaillllllllll"
      mg_user_id.each do |user|

        @email_from = MgEmail.where(:mg_user_id => session[:user_id])
        @email_to = MgEmail.where(:mg_user_id => user)
        
        if @email_to.present?
          @message.to_user_id = @email_to[0][:mg_email_id ]
          if @email_from.present?
            @message.from_user_id = @email_from[0][:mg_email_id ]
          else
            @message.from_user_id = "abc@mindcomgroup.com"
          end
          server_response = NotificationMailer.send_mail(@message).deliver!
          
          db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id] ,
                    :to_user_id => user.to_i,
                    :subject => @message.subject,
                    :description => @message.description,
                    :is_deleted => 0,
                    :from_user_id =>session[:user_id],
                    :status => 0)
          @event_mail = MgMailStatus.create(:status_code => server_response.status,
                                      :email_addrs_to => @message.to_user_id,
                                :mg_school_id => session[:current_user_school_id] ,
                                      :email_addrs_by => @message.from_user_id,
                                      :email_subject => 'test',
                                     :email_server_description => server_description(server_response.status) )
        else
          puts "Email id is not present"
        end
      end
      return @notice="Mail Sent Successfully."
    rescue Net::SMTPFatalError => e
      puts "inside Exception in principal"
      puts e
      return @notice="Email Id is not valid."
    rescue ArgumentError => e
      puts "inside Exception in principal"
      puts e
      return @notice="Email to address is not present."
    rescue Exception => e
      puts e
      puts "inside Exception in principal"
      return @notice="Error while sending email,Please contact admin."
    end
  end

  def specialization
    @specialization = MgSpecialization.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def new_specialization
    @action='new'
    @specialization=MgSpecialization.new
    render :layout=>false
  end

  def create_specialization
    @specialization=MgSpecialization.new(params_specialization)
    if @specialization.save
      flash[:notice]="Specialization created successfully"
    else
      flash[:error]="Error Occured please check duplicate name"
    end
    redirect_to :action=>'specialization'
  end

  def show_specialization
    @specialization=MgSpecialization.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def edit_specialization
    @action='edit'
    @specialization=MgSpecialization.find_by(:id=>params[:id])
    render :layout=>false
  end

  def update_specialization
    @specialization=MgSpecialization.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    if @specialization.update(params_specialization)
        flash[:notice]="Specialization updated successfully"
    else
      flash[:error]="Error Occured please check duplicate name"
    end
    redirect_to :action=>'specialization'
  end

  def delete_specialization
    @specialization=MgSpecialization.find_by(:id=>params[:id], :mg_school_id=>session[:current_user_school_id])
    if @specialization.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Specialization deleted successfully"
    else
      flash[:error]="Specialization deleted unsuccessfully"
    end
    redirect_to :action=>'specialization'
  end



  private
  def params_vaccinations
    params.require(:vaccinations).permit(:name,:description,:age_recommended,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end

  def params_booster_doses
    params.require(:booster_doses).permit(:name,:description,:frequency,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end

  def vaccinations_details_params
    params.require(:vaccinations).permit(:mg_school_id,:is_deleted,:created_by,:updated_by)
  end
  # def booster_doses_details_params
  #   params.require(:booster_doses).permit(:mg_school_id,:is_deleted,:created_by,:updated_by)
  # end

  def user_accounts_params
    params.require(:doctor).permit(:user_type,:mg_specialization_id,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def allergy_params
    params.require(:allergy).permit(:name,:description,:status,:medication_detail,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end
  
  def bed_detail_params
    params.require(:bed_detail).permit(:bed_no,:description,:status,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end

  def bed_assign_details_params
    params.require(:bed_assign_detail).permit(:mg_bed_details_id,:admitted_date,:admitted_time,:user_id,:status,:mg_doctor_id,:comments,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end

  def update_bed_assign_details_params
    params.require(:bed_assign_detail).permit(:mg_bed_details_id,:admitted_time,:discharge_time,:user_id,:mg_doctor_id,:comments,:status,:mg_school_id,:is_deleted,:updated_by)
  end

  def checkup_schedule_params
    params.require(:checkup_schedule).permit(:mg_doctor_id,:doctor_name,:mg_check_up_type_id,:date,:start_time,:end_time,:checkup_for,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end
  # Jitendra added end 
  def checkup_type_params_data
		params.require(:checkup_type).permit(:name,:description,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end	

  def update_checkup_type_params
		params.require(:checkup_type).permit(:name,:description,:mg_school_id,:is_deleted,:updated_by)
  end
  def healthcare_admin_params
    params.require(:healthcare_admin).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

  def params_specialization
    params.require(:specialization).permit(:name,:description,:mg_school_id,:is_deleted,:created_by,:updated_by)
  end
end

