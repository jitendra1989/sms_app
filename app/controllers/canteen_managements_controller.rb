class CanteenManagementsController < ApplicationController
  layout "mindcom"
  before_filter :login_required

  def index
    @food_item_details=MgFoodItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end
  
  def new
    @action='new'
    render :layout=>false
  end

  def create
    @food_items=MgFoodItem.new(food_item_params)
    if @food_items.save
      flash[:notice]="Successfully Created"
    else
      flash[:error]="Error Occured"
    end
    redirect_to canteen_managements_path#:action=>'index'
  end

  def show
    @food_items=MgFoodItem.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    render :layout=>false
  end

  def edit
    @action='edit'
    @food_items=MgFoodItem.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    render :layout=>false
  end

  def update
    @food_items=MgFoodItem.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    if @food_items.update(food_item_params)
      flash[:notice]="Successfully Update"
    else
      flash[:error]="Error Occured"
    end
    redirect_to canteen_managements_path
  end

  def delete
    @food_items=MgFoodItem.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    if @food_items.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Successfully Delete"
    else
      flash[:error]="Error Occured"
    end
    redirect_to canteen_managements_path
  end

  def meal_category
    @meal_category=MgMealCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("priority ASC").paginate(page: params[:page], per_page: 10)
  end

  def new_meal_category
    @action='new'
    render :layout=>false
  end

  def create_meal_category
    @meal_category=MgMealCategory.new(meal_category_params)
    if @meal_category.save
      flash[:notice]="Successfully Created"
    else
      flash[:error]="Error Occured please check duplicate priority"
    end
    redirect_to meal_category_path
  end

  def show_meal_category
    @meal_category=MgMealCategory.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    render :layout=>false
  end

  def edit_meal_category
    @action='edit'
    @meal_category=MgMealCategory.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    render :layout=>false
  end

  def update_meal_category
    @meal_category=MgMealCategory.find_by(:id=>params[:meal_category][:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    if @meal_category.update(meal_category_params)
      flash[:notice]="Successfully Update"
    else
      flash[:error]="Error Occured please check duplicate priority"
    end
    redirect_to meal_category_path
  end

  def delete_meal_category
    @meal_category=MgMealCategory.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id],:is_deleted=>0)
    if @meal_category.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Successfully Delete"
    else
      flash[:error]="Error Occured"
    end
    redirect_to meal_category_path
  end

  def regular_menu
    @regular_menu=MgCanteenRegularMenu.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
    # @meal_category=MgMealCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order("priority ASC").paginate(page: params[:page], per_page: 10)
  end

  def new_regular_menu
    @action='new'
    @food_item=MgFoodItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:category=>"short shelf life").pluck(:item_name,:id)
    # @regular_menu=MgCanteenRegularMenu.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end
   
  def create_regular_menu
    @regula_menu_id=params[:mg_food_item_id]
    if @regula_menu_id !=''
     
      @regula_menu_id.each do |id|
        regular_menu=MgCanteenRegularMenu.new()
        regular_menu.mg_food_item_id=id
        regular_menu.status="pending"
        regular_menu.is_deleted=0
        regular_menu.created_by=session[:user_id]
        regular_menu.updated_by=session[:user_id]
        regular_menu.mg_school_id=session[:current_user_school_id]
        regular_menu.save
      end
    end

    flash[:notice]="Successfully Created"
    redirect_to regular_menu_path
  end

  def show_regular_menu
  end

  def edit_regular_menu
    @action='edit'
    @food_item=MgFoodItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:category=>"short shelf life").pluck(:item_name,:id)
    @regular_menu=MgCanteenRegularMenu.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def update_regular_menu
    # puts qwerty
    @regular_food_id =params[:regular_food_id]
    if params[:regular_food_id].present?
      params[:regular_food_id].each_with_index do |mg_food_item_id,index|
        regular_menu = MgCanteenRegularMenu.find_by(:mg_food_item_id=>mg_food_item_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        temp=0
        temp=index+1
        regular_menu.update(:is_deleted=>1,:updated_by=>session[:user_id],:status=>params[:status][temp.to_s])
      end
    end
    params[:mg_food_item_id].each_with_index do |food_item_id,index|
      if @regular_food_id.include? food_item_id
        regular_menu = MgCanteenRegularMenu.where(:mg_food_item_id=>food_item_id,:mg_school_id=>session[:current_user_school_id]).last
        regular_menu.update(:is_deleted=>0,:updated_by=>session[:user_id])
      else
        if food_item_id!=''
          new_regular_menu=MgCanteenRegularMenu.new()
          new_regular_menu.mg_food_item_id=food_item_id
          if session[:user_type]=="principal"
            new_regular_menu.status="accepted"
          else
            new_regular_menu.status="pending"
          end
          new_regular_menu.is_deleted=0
          new_regular_menu.created_by=session[:user_id]
          new_regular_menu.updated_by=session[:user_id]
          new_regular_menu.mg_school_id=session[:current_user_school_id]
          new_regular_menu.save
        end
      end
    end
    flash[:notice]="Successfully Updated"
    redirect_to regular_menu_path
  end

  def delete_regular_menu
     regular_menu=MgCanteenRegularMenu.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id])
    if regular_menu.update(:is_deleted=>1,:updated_by=>session[:user_id])
      flash[:notice]="Successfully Delete"
    else
      flash[:error]="Error Occured"
    end
    redirect_to regular_menu_path
  end

  def bill_detail
    @bill_detail=MgCanteenBillDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end

  def new_bill_genereate
    @action='new'
    @food_item=MgFoodItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:category=>"short shelf life").pluck(:item_name,:id)
  end

  def create_bill_detail
    array=[]
    puts "00000000000000"
    puts params
    puts "00000000000000"
    # MgCanteenBillDetail.transaction do
      paid_amount=params[:paid_amount][0].to_i

     

      if params[:bill_detail][:checkup_for]=="select_user"
        #=========today==========================
        if params[:bill_detail][:user_type]=="student"
          @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          if @canteen_bill_details.present?
            @canteen_bill_details.each do |bill_object|
              bill_object.update(:balance_amount=>0)
            end
          end
        else
          @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:bill_detail][:mg_employee_department_id],:mg_employee_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          if @canteen_bill_details.present?
            @canteen_bill_details.each do |bill_object|
              bill_object.update(:balance_amount=>0)
            end
          end
        end
        #=========today==========================
        bill_detail=MgCanteenBillDetail.new(bill_detail_params)
        bill_detail.paid_amount=params[:paid_amount][0]
        bill_detail.balance_amount=params[:balance_amount][0]
        bill_detail.total_amount=params[:total_amount][0]

        if params[:bill_detail][:user_type]=="student"
          student_user_id=MgStudent.find_by(:id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          bill_detail.mg_user_id=student_user_id.mg_user_id
        else
          employee_user_id=MgEmployee.find_by(:id=>params[:bill_detail][:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          bill_detail.mg_user_id=employee_user_id.mg_user_id
        end

        array.push(bill_detail.save)

        if bill_detail.save
          params[:mg_food_item_id].each do |key,value|
            bill_payment_detail=MgCanteenBillPayment.new()
            bill_payment_detail.mg_canteen_bill_detail_id=bill_detail.id
            bill_payment_detail.mg_food_item_id=value
            bill_payment_detail.quantity=params[:quantity][key]
            bill_payment_detail.unit_quantity=params[:unit_quantity][key]
            bill_payment_detail.amount=params[:total_price][key]
            bill_payment_detail.is_deleted=0
            bill_payment_detail.mg_school_id=session[:current_user_school_id]
            bill_payment_detail.created_by=session[:user_id]
            bill_payment_detail.updated_by=session[:user_id]
            array.push(bill_payment_detail.save)
          end
        end

        #===========walleettttttttt start=======================
        if params[:wallet_amount][0].to_i>=0
          wallet_total=params[:wallet_amount][0].to_i
          if params[:use_wallet_amount].present?

            if params[:bill_detail][:user_type]=="student"
              @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            else
              @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:bill_detail][:mg_employee_department_id],:mg_employee_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            end
            puts"------------------step1--------------------"

            if @canteen_bill_details.present?
              @canteen_bill_details.each do |bill_object|
                if bill_object.balance_amount.to_i>0
                  puts"------------------step1.1--------------------"
                  puts bill_object.balance_amount
                  puts"------------------step1.1--------------------"

                  if (wallet_total>0) && (wallet_total>=bill_object.balance_amount.to_i)
                    wallet_total=wallet_total-bill_object.balance_amount.to_i
                    puts"------------------step2--------------------"
                    puts wallet_total
                    puts"------------------step2--------------------"
                    array.push(bill_object.update(:balance_amount=>0,:updated_by=>session[:user_id]))
                  elsif (wallet_total>0) && (wallet_total<=bill_object.balance_amount.to_i)
                    net_balance_amount=bill_object.balance_amount.to_i-wallet_total

                    wallet_total=0
                    puts"------------------step3--------------------"
                    puts wallet_total
                    puts"------------------step3--------------------"
                    array.push(bill_object.update(:balance_amount=>net_balance_amount,:updated_by=>session[:user_id]))
                  end
                end #bill_object
              end
            end
            if params[:bill_detail][:user_type]=="student"
              wallet_obj=MgCanteenWalletAmount.where(:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            else
              wallet_obj=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:bill_detail][:mg_employee_department_id],:mg_employee_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            end

            if wallet_obj.present?
              wallet_obj.update_all(:wallet_amount=>wallet_total.to_i,:updated_by=>session[:user_id])
            else
              wallet_obj=MgCanteenWalletAmount.new(:user_type=>params[:bill_detail][:user_type],:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:wallet_amount=>wallet_total.to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
              wallet_obj.save

              if params[:bill_detail][:user_type]=="student"
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>params[:bill_detail][:user_type],:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:wallet_amount=>wallet_total.to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              else
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>params[:bill_detail][:user_type],:mg_employee_department_id=>params[:bill_detail][:mg_employee_department_id],:mg_employee_id=>params[:bill_detail][:mg_employee_id],:wallet_amount=>wallet_total.to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              end
            end
          else
            puts"------------------step5--------------------"
            puts wallet_total
            puts"------------------step5--------------------"
            if params[:bill_detail][:user_type]=="student"
              wallet_obj=MgCanteenWalletAmount.where(:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            else
              wallet_obj=MgCanteenWalletAmount.where(:mg_employee_department_id=>params[:bill_detail][:mg_employee_department_id],:mg_employee_id=>params[:bill_detail][:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            end

            if wallet_obj.present?
              wallet_obj.update_all(:wallet_amount=>params[:wallet_amount][0].to_i,:updated_by=>session[:user_id])
            else
              if params[:bill_detail][:user_type]=="student"
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>params[:bill_detail][:user_type],:mg_batch_id=>params[:bill_detail][:mg_batch_id],:mg_student_id=>params[:bill_detail][:mg_student_id],:wallet_amount=>params[:wallet_amount][0].to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              else
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>params[:bill_detail][:user_type],:mg_employee_department_id=>params[:bill_detail][:mg_employee_department_id],:mg_employee_id=>params[:bill_detail][:mg_employee_id],:wallet_amount=>params[:wallet_amount][0].to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              end
            end
          end
        end
        #===========walleettttttttt enddd=====================
      else
        bill_detail=MgCanteenBillDetail.new(bill_detail_params)
        bill_detail.paid_amount=params[:paid_amount][0]
        bill_detail.balance_amount=params[:balance_amount][0]
        bill_detail.total_amount=params[:total_amount][0]

        if params[:student_id_list]!="" || params[:student_name_list]!=""
          if params[:student_id_list]!=''
            student_id=params[:student_id_list]
          else
            student_id=params[:student_name_list]
          end
          student_user_id=MgStudent.find_by(:id=>student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          bill_detail.mg_user_id=student_user_id.mg_user_id
          bill_detail.mg_student_id=student_id
          bill_detail.mg_batch_id=student_user_id.mg_batch_id
          bill_detail.user_type='student'
        else
          if params[:employee_name_list]!=''
            employee_id=params[:employee_name_list]
          else
            employee_id=params[:employee_id_list]
          end
          employee_user_id=MgEmployee.find_by(:id=>employee_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
          bill_detail.mg_user_id=employee_user_id.mg_user_id
          bill_detail.mg_employee_id=employee_id
          bill_detail.mg_employee_department_id=employee_user_id.mg_employee_department_id
          bill_detail.user_type='employee'
        end

        array.push(bill_detail.save)
        if bill_detail.save
          params[:mg_food_item_id].each do |key,value|
            bill_payment_detail=MgCanteenBillPayment.new()
            bill_payment_detail.mg_canteen_bill_detail_id=bill_detail.id
            bill_payment_detail.mg_food_item_id=value
            bill_payment_detail.quantity=params[:quantity][key]
            bill_payment_detail.unit_quantity=params[:unit_quantity][key]
            bill_payment_detail.amount=params[:total_price][key]
            bill_payment_detail.is_deleted=0
            bill_payment_detail.mg_school_id=session[:current_user_school_id]
            bill_payment_detail.created_by=session[:user_id]
            bill_payment_detail.updated_by=session[:user_id]
            array.push(bill_payment_detail.save)
          end
        end
        #===========walleettttttttt start=======================
        #=========today==========================
        if bill_detail.user_type=="student"
          puts"insideeeeeeee studenttttt"
          puts bill_detail.id
          puts"insideeeeeeee studenttttt"
          @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>student_user_id.mg_batch_id,:mg_student_id=>student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where.not(:id=>bill_detail.id)
          if @canteen_bill_details.present?
            @canteen_bill_details.each do |bill_object|
              bill_object.update(:balance_amount=>0)
            end
          end
        else
          puts"insideeeeeeee emp"
          puts bill_detail.id
          puts"insideeeeeeee emp"
          @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>employee_user_id.mg_employee_department_id,:mg_employee_id=>employee_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where.not(:id=>bill_detail.id)
          if @canteen_bill_details.present?
            @canteen_bill_details.each do |bill_object|
              bill_object.update(:balance_amount=>0)
            end
          end
        end
        #=========today==========================

        if params[:wallet_amount][0].to_i>=0
          wallet_total=params[:wallet_amount][0].to_i
          if params[:use_wallet_amount].present?

            if bill_detail.user_type=="student"
              @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>student_user_id.mg_batch_id,:mg_student_id=>student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            else
              @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>employee_user_id.mg_employee_department_id,:mg_employee_id=>employee_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            end
            puts"------------------step1--------------------"
            puts"------------------step1--------------------"

            if @canteen_bill_details.present?
              @canteen_bill_details.each do |bill_object|
                if bill_object.balance_amount.to_i>0
                  puts"------------------step1.1--------------------"
                  puts bill_object.balance_amount
                  puts"------------------step1.1--------------------"

                  if (wallet_total>0) && (wallet_total>=bill_object.balance_amount.to_i)
                    wallet_total=wallet_total-bill_object.balance_amount.to_i
                    puts"------------------step2--------------------"
                    puts wallet_total
                    puts"------------------step2--------------------"
                    array.push(bill_object.update(:balance_amount=>0,:updated_by=>session[:user_id]))
                  elsif (wallet_total>0) && (wallet_total<=bill_object.balance_amount.to_i)
                    net_balance_amount=bill_object.balance_amount.to_i-wallet_total

                    wallet_total=0
                    puts"------------------step3--------------------"
                    puts wallet_total
                    puts"------------------step3--------------------"
                    array.push(bill_object.update(:balance_amount=>net_balance_amount,:updated_by=>session[:user_id]))
                  end
                end #bill_object
              end
            end
            if bill_detail.user_type=="student"
              wallet_obj=MgCanteenWalletAmount.where(:mg_batch_id=>student_user_id.mg_batch_id,:mg_student_id=>student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            else
              wallet_obj=MgCanteenWalletAmount.where(:mg_employee_department_id=>employee_user_id.mg_employee_department_id,:mg_employee_id=>employee_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            end

            if wallet_obj.present?
              wallet_obj.update_all(:wallet_amount=>wallet_total.to_i,:updated_by=>session[:user_id])
            else
              if bill_detail.user_type=="student"
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>bill_detail.user_type,:mg_batch_id=>student_user_id.mg_batch_id,:mg_student_id=>student_id,:wallet_amount=>wallet_total.to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              else
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>bill_detail.user_type,:mg_employee_department_id=>employee_user_id.mg_employee_department_id,:mg_employee_id=>employee_id,:wallet_amount=>wallet_total.to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              end
            end
          else
            puts"------------------step5--------------------"
            puts wallet_total
            puts"------------------step5--------------------"
            if bill_detail.user_type=="student"
              wallet_obj=MgCanteenWalletAmount.where(:mg_batch_id=>student_user_id.mg_batch_id,:mg_student_id=>student_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            else
              wallet_obj=MgCanteenWalletAmount.where(:mg_employee_department_id=>employee_user_id.mg_employee_department_id,:mg_employee_id=>employee_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
            end

            if wallet_obj.present?
              wallet_obj.update_all(:wallet_amount=>params[:wallet_amount][0].to_i,:updated_by=>session[:user_id])
            else
              if bill_detail.user_type=="student"
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>bill_detail.user_type,:mg_batch_id=>student_user_id.mg_batch_id,:mg_student_id=>student_id,:wallet_amount=>params[:wallet_amount][0].to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              else
                wallet_obj=MgCanteenWalletAmount.new(:user_type=>bill_detail.user_type,:mg_employee_department_id=>employee_user_id.mg_employee_department_id,:mg_employee_id=>employee_id,:wallet_amount=>params[:wallet_amount][0].to_i,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:created_by=>session[:user_id],:updated_by=>session[:user_id])
                wallet_obj.save
              end
            end
          end
        end
        #===========walleettttttttt enddd=====================
      end
      if array.include?(false)
        raise ActiveRecord::Rollback
      end
    # end #end of transaction
    if array.include?(false)
      flash[:error]="Error Occured"
    else
      flash[:notice]="Successfully Created"
    end

    redirect_to :controller=>'canteen_managements',:action=>'bill_detail'
  end

  def show_bill_detail
    @canteen_bill_details=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @bill_payment_detail=MgCanteenBillPayment.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def edit_bill_detail
    @food_item=MgFoodItem.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:category=>"short shelf life").pluck(:item_name,:id)
    @canteen_bill_details=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @bill_payment_detail=MgCanteenBillPayment.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end

  def update_bill_detail
    array=[]

    MgCanteenBillDetail.transaction do
      previous_food_id=params[:previous_food_id]
      canteen_detail=MgCanteenBillDetail.find_by(:id=>params[:bill_detail][:id])
      canteen_detail.update(:total_amount=>params[:total_amount][0],:paid_amount=>params[:paid_amount][0],:balance_amount=>params[:balance_amount][0],:updated_by=>session[:user_id])

      params[:previous_food_id].each do |id|
        payment_obj=MgCanteenBillPayment.find_by(:mg_food_item_id=>id,:mg_canteen_bill_detail_id=>params[:bill_detail][:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        array.push(payment_obj.update(:is_deleted=>1,:updated_by=>session[:user_id]))
      end

      params[:mg_food_item_id].each do |key,value|
        if previous_food_id.include?(value)
          payments_obj=MgCanteenBillPayment.find_by(:mg_food_item_id=>value,:mg_canteen_bill_detail_id=>params[:bill_detail][:id],:mg_school_id=>session[:current_user_school_id])
          array.push(payments_obj.update(:is_deleted=>0,:quantity=>params[:quantity][key],:unit_quantity=>params[:unit_quantity][key],:amount=>params[:total_price][key]))
        else
          bill_payment_detail=MgCanteenBillPayment.new()
          bill_payment_detail.mg_canteen_bill_detail_id=params[:bill_detail][:id]
          bill_payment_detail.mg_food_item_id=value
          bill_payment_detail.quantity=params[:quantity][key]
          bill_payment_detail.unit_quantity=params[:unit_quantity][key]
          bill_payment_detail.amount=params[:total_price][key]
          bill_payment_detail.is_deleted=0
          bill_payment_detail.mg_school_id=session[:current_user_school_id]
          bill_payment_detail.created_by=session[:user_id]
          bill_payment_detail.updated_by=session[:user_id]
          array.push(bill_payment_detail.save)
        end
      end
      if array.include?(false)
        raise ActiveRecord::Rollback
      end
    end
    if array.include?(false)
      flash[:error]="Error Occured"
    else
      flash[:notice]="Successfully Updated"
    end
    redirect_to :controller=>'canteen_managements',:action=>'bill_detail'
  end

  def delete_bill_detail
    array=[]
    MgCanteenBillDetail.transaction do
      bill_detail=MgCanteenBillDetail.find_by(:id=>params[:id],:mg_school_id=>session[:current_user_school_id])
      if array.push(bill_detail.update(:is_deleted=>1,:updated_by=>session[:user_id]))
        payment_obj=MgCanteenBillPayment.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        array.push(payment_obj.update_all(:is_deleted=>1,:updated_by=>session[:user_id]))
        balance_amount=MgCanteenBalanceAmount.where("is_deleted=? and mg_school_id=? and mg_canteen_bill_detail_id=?",0,session[:current_user_school_id],params[:id])
        if balance_amount.present?
          array.push(balance_amount.update_all(:is_deleted=>1,:updated_by=>session[:user_id]))
        end
      end
      if array.include?(false)
        raise ActiveRecord::Rollback
      end
    end

    if array.include?(false)
      flash[:error]="Error Occured"
    else
      flash[:notice]="Successfully Delete"
    end
    redirect_to :controller=>'canteen_managements',:action=>'bill_detail'
  end

  def student_details
    @student_list = MgStudent.where(:is_deleted=>0, :mg_batch_id=>params[:mg_batch_id], :mg_school_id=>session[:current_user_school_id])#.where.not(:id=>stu_data)
    respond_to do |format|
      format.json  { render :json => @student_list }
    end
  end

  def student_amount_details
    @total_balance_amount=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
     puts @total_balance_amount
     respond_to do |format|
      format.json  { render :json => @total_balance_amount }
    end
  end

  def employee_details
    @employee_list = MgEmployee.where(:is_deleted=>0, :mg_employee_department_id=>params[:mg_employee_department_id], :mg_school_id=>session[:current_user_school_id])#.where.not(:id=>emp_data)
    respond_to do |format|
      format.json  { render :json => @employee_list }
    end
  end

  def total_price
    @food_price = MgFoodItem.where(:id=>params[:food_item_id],:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])#.pluck(:price)
    #@total_price=@food_price[0].to_i*params[:food_quantity].to_i
    respond_to do |format|
      format.json  { render :json => @food_price }
    end
  end

  def balance_amount
    @balance_amount=MgCanteenBillDetail.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).group(:mg_user_id).order("id asc").paginate(page: params[:page], per_page: 10)
  end

  
  def pay_balance_amount
    if params[:id].present?
      @bill_detail_object=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end
  end
  # @total_balance_amount

  def balance_details
    if params[:user_type]=="student"
      @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @total_balance_amount=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
      @wallet_amount=MgCanteenWalletAmount.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"student",:mg_student_id=>params[:mg_student_id])
    else
      @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @total_balance_amount=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
      @wallet_amount=MgCanteenWalletAmount.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:user_type=>"employee",:mg_employee_id=>params[:mg_employee_id])
    end
    render :layout=>false
  end

  def update_balance_amount
    # update_bill_detail
    array=[]
    paid_amount=params[:paid_amount][0].to_i

    MgCanteenBillDetail.transaction do
      if params[:pay_balance_amount][:user_type]=="student"
        # ======================================================================================================================================
        studentData=MgCanteenWalletAmount.find_by(:user_type=>"student",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_student_id=>params[:pay_balance_amount][:mg_student_id])
        if params[:wallet_balance_check][0]=='true'
          studentData.update(:wallet_amount=>params[:wallet_balance_amount][0].to_i)
        else
          if params[:balance_amount][0].to_i < params[:paid_amount][0].to_i
              studentData.update(:wallet_amount=>(params[:paid_amount][0].to_i - params[:balance_amount][0].to_i))
          end
        end
        # ======================================================================================================================================
        @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>params[:pay_balance_amount][:mg_batch_id],:mg_student_id=>params[:pay_balance_amount][:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @canteen_bill_details.each do |bill_object|
          if bill_object.balance_amount.to_i>0
            if (paid_amount>0) && (paid_amount>=bill_object.balance_amount.to_i)
              canteen_balance_amount = MgCanteenBalanceAmount.new(:mg_canteen_bill_detail_id=>bill_object.id,:paid_amount=>bill_object.balance_amount.to_i,
                :mg_school_id=>session[:current_user_school_id],:updated_by=>session[:user_id],:created_by=>session[:user_id],:is_deleted=>0)
              array.push(canteen_balance_amount.save)
              paid_amount=paid_amount-bill_object.balance_amount.to_i
              array.push(bill_object.update(:balance_amount=>0,:updated_by=>session[:user_id]))
            elsif (paid_amount>0) && (paid_amount<=bill_object.balance_amount.to_i)
              canteen_balance_amount = MgCanteenBalanceAmount.new(:mg_canteen_bill_detail_id=>bill_object.id,:paid_amount=>paid_amount.to_i,
                :mg_school_id=>session[:current_user_school_id],:updated_by=>session[:user_id],:created_by=>session[:user_id],:is_deleted=>0)
              array.push(canteen_balance_amount.save)
              net_balance_amount=bill_object.balance_amount.to_i-paid_amount

              paid_amount=paid_amount-bill_object.balance_amount.to_i
              array.push(bill_object.update(:balance_amount=>net_balance_amount,:updated_by=>session[:user_id]))
            end
          end #bill_object
        end #end of @canteen_bill_details.each
      else
        # ======================================================================================================================================
        employeeData=MgCanteenWalletAmount.find_by(:user_type=>"employee",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_id=>params[:pay_balance_amount][:mg_employee_id])
        if params[:wallet_balance_check]=='true'
          employeeData.update(:wallet_amount=>params[:wallet_balance_amount][0].to_i)
        else
          if params[:balance_amount][0].to_i < params[:paid_amount][0].to_i
              employeeData.update(:wallet_amount=>(params[:paid_amount][0].to_i - params[:balance_amount][0].to_i))
          end
        end
        # ======================================================================================================================================
     
        @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:pay_balance_amount][:mg_employee_department_id],:mg_employee_id=>params[:pay_balance_amount][:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @canteen_bill_details.each do |bill_object|
          if bill_object.balance_amount.to_i>0
            if (paid_amount>0) && (paid_amount>=bill_object.balance_amount.to_i)
              canteen_balance_amount = MgCanteenBalanceAmount.new(:mg_canteen_bill_detail_id=>bill_object.id,:paid_amount=>bill_object.balance_amount.to_i,
                :mg_school_id=>session[:current_user_school_id],:updated_by=>session[:user_id],:created_by=>session[:user_id],:is_deleted=>0)
              array.push(canteen_balance_amount.save)
              paid_amount=paid_amount-bill_object.balance_amount.to_i
              array.push(bill_object.update(:balance_amount=>0,:updated_by=>session[:user_id]))
            elsif (paid_amount>0) && (paid_amount<=bill_object.balance_amount.to_i)
              canteen_balance_amount = MgCanteenBalanceAmount.new(:mg_canteen_bill_detail_id=>bill_object.id,:paid_amount=>paid_amount.to_i,
                :mg_school_id=>session[:current_user_school_id],:updated_by=>session[:user_id],:created_by=>session[:user_id],:is_deleted=>0)
              array.push(canteen_balance_amount.save)
              net_balance_amount=bill_object.balance_amount.to_i-paid_amount
              paid_amount=paid_amount-bill_object.balance_amount.to_i
              array.push(bill_object.update(:balance_amount=>net_balance_amount,:updated_by=>session[:user_id]))
            end
          end #bill_object
        end #end of @canteen_bill_details.each
      end
      if array.include?(false)
        raise ActiveRecord::Rollback
      end
    end #end of transaction
    if array.include?(false)
      flash[:error]="Error Occured"
    else
      flash[:notice]="Balance amount Successfully Paid"
    end
    
    redirect_to :controller=>'canteen_managements',:action=>'balance_amount'
  end

  def show_bill_history
    @canteen_bill_details=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @bill_payment_detail=MgCanteenBillPayment.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end
  
  def balance_paid_history
    @canteen_bill_details=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    @balance_paid_detail=MgCanteenBalanceAmount.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    render :layout=>false
  end

  def show_all_bill_history
    @bill_detail_object=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
  end



  def show_balance_details
    if params[:user_type]=="student"
      @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @total_balance_amount=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
    else
      @canteen_bill_details=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      @total_balance_amount=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
    end
    render :layout=>false
  end


  def show_particular_balance_details
    if params[:user_type]=="student"
      @total_amount=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("total_amount")
      @total_balance_amount=MgCanteenBillDetail.where(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
      wallet_amount_details=MgCanteenWalletAmount.find_by(:mg_batch_id=>params[:mg_batch_id],:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      if wallet_amount_details.present?
        wallet_amount=wallet_amount_details.wallet_amount.to_s
      else
        wallet_amount=0
      end
    else
      @total_amount=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("total_amount")
      @total_balance_amount=MgCanteenBillDetail.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
      wallet_amount_details=MgCanteenWalletAmount.where(:mg_employee_department_id=>params[:mg_employee_department_id],:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      if wallet_amount_details.present?
        wallet_amount=wallet_amount_details.wallet_amount.to_s
      else
        wallet_amount=0
      end
    end
    # @total_and_balance_amount=@total_amount.to_s+"-"+@total_balance_amount.to_s
    # @total_and_balance_amount=@total_and_balance_amount.to_json
    @total_and_balance_amount={:total_amount=>@total_amount.to_s, :balance_amount=>@total_balance_amount.to_s, :wallet_amount=>wallet_amount}
    respond_to do |format|
      format.json  { render :json => @total_and_balance_amount }
    end
  end

  def show_particular_search_balance_details
    if params[:user_type]=="student_id" || params[:user_type]=="student_name"
      batch=MgStudent.find_by(:id=>params[:mg_student_id])
      @total_amount=MgCanteenBillDetail.where(:mg_batch_id=>batch.mg_batch_id,:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("total_amount")
      @total_balance_amount=MgCanteenBillDetail.where(:mg_batch_id=>batch.mg_batch_id,:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
      wallet_amount_details=MgCanteenWalletAmount.find_by(:mg_batch_id=>batch.mg_batch_id,:mg_student_id=>params[:mg_student_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      if wallet_amount_details.present?
        wallet_amount=wallet_amount_details.wallet_amount.to_s
      else
        wallet_amount=0
      end
    elsif params[:user_type]=="employee_id" || params[:user_type]=="employee_name"
      department=MgEmployee.find_by(:id=>params[:mg_employee_id])
      @total_amount=MgCanteenBillDetail.where(:mg_employee_department_id=>department.mg_employee_department_id,:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("total_amount")
      @total_balance_amount=MgCanteenBillDetail.where(:mg_employee_department_id=>department.mg_employee_department_id,:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).sum("balance_amount")
      wallet_amount_details=MgCanteenWalletAmount.find_by(:mg_employee_department_id=>department.mg_employee_department_id,:mg_employee_id=>params[:mg_employee_id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
      if wallet_amount_details.present?
        wallet_amount=wallet_amount_details.wallet_amount.to_s
      else
        wallet_amount=0
      end
    end
    # @total_and_balance_amount=@total_amount.to_s+"-"+@total_balance_amount.to_s
    # @total_and_balance_amount=@total_and_balance_amount.to_json
    @total_and_balance_amount={:total_amount=>@total_amount.to_s, :balance_amount=>@total_balance_amount.to_s, :wallet_amount=>wallet_amount}
    respond_to do |format|
      format.json  { render :json => @total_and_balance_amount }
    end
  end
  

  def bill_detail_pdf
    @school=MgSchool.find(session[:current_user_school_id])
    @school_logo=@school.logo.url(:medium,:timestamp=>false)
    @date_format = MgSchool.find_by(:id=>session[:current_user_school_id]).date_format
    
    bill_details_obj=MgCanteenBillDetail.find_by(:id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

    if bill_details_obj.user_type=="student"
      @student_id=bill_details_obj.mg_student_id
      @batch_id=bill_details_obj.mg_batch_id
      @food_item_detail=MgCanteenBillPayment.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    else
      @employee_id=bill_details_obj.mg_employee_id
      @employee_department_id=bill_details_obj.mg_employee_department_id
      @food_item_detail=MgCanteenBillPayment.where(:mg_canteen_bill_detail_id=>params[:id],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = CanteenBillDetail.new(@school,@date_format,@school_logo,@student_id,@batch_id,@employee_id,@employee_department_id,@food_item_detail,bill_details_obj)
        send_data pdf.render, filename: 
        "canteen_bill#{DateTime.now.strftime(@date_format)}.pdf",
        type: "application/pdf", :disposition => 'inline'
      end
    end
  end

  def search_student_employee_details
    if params[:search_by]=="search_by_student_id"
      split_data=params[:student_id]
      array_data=split_data.to_s.split(" ")
      str=""
      if array_data.present?
        for s in 0..array_data.size-1
          str +=" admission_number LIKE '%#{array_data[s]}%'"
          # str +=" admission_number LIKE '%#{array_data[s]}%' or employee_number LIKE '%#{array_data[s]}%'"
          if s<array_data.size-1
            str+=" or "
          end
        end
      end
      @search_result=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    elsif params[:search_by]=="search_by_employee_id"
      split_data=params[:employee_id]
      array_data=split_data.to_s.split(" ")
      str=""
      if array_data.present?
        for s in 0..array_data.size-1
          str +=" employee_number LIKE '%#{array_data[s]}%'"
          # str +=" admission_number LIKE '%#{array_data[s]}%' or employee_number LIKE '%#{array_data[s]}%'"
          if s<array_data.size-1
            str+=" or "
          end
        end
      end
      @search_result=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    elsif params[:search_by]=="search_by_student_name"
      split_data=params[:student_name]
      array_data=split_data.to_s.split(" ")
      str=""
      if array_data.present?
        for s in 0..array_data.size-1
          # str +=" employee_number LIKE '%#{array_data[s]}%'"
          str +=" first_name LIKE '%#{array_data[s]}%' or last_name LIKE '%#{array_data[s]}%'"
          if s<array_data.size-1
            str+=" or "
          end
        end
      end
      @search_result=MgStudent.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)
    elsif params[:search_by]=="search_by_employee_name"
      split_data=params[:employee_name]
      array_data=split_data.to_s.split(" ")
      str=""
      if array_data.present?
        for s in 0..array_data.size-1
          # str +=" employee_number LIKE '%#{array_data[s]}%'"
          str +=" first_name LIKE '%#{array_data[s]}%' or last_name LIKE '%#{array_data[s]}%'"
          if s<array_data.size-1
            str+=" or "
          end
        end
      end
      @search_result=MgEmployee.where("is_deleted=? and mg_school_id=?",0,session[:current_user_school_id]).where(str)

    end #end of first if search_by

    respond_to do |format|
      format.json  { render :json => @search_result }
    end
  end

	def menu
      @canteen=MgCanteen.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
	end

	def new_menu
		
	end

	def create_menu
		@food_item=MgCanteen.new(new_menu_create)
		@food_item.save
    @food_item.update(:status=>'Pending')
		params[:mg_food_item_id].each_with_index do |data, index|
			str=data.to_s
			key= str.slice(2, 3)
			params[:mg_food_item_id][key].each_with_index do |value|
				@food_canteen_item=MgCanteenMeal.new(new_canteen_create)
				@food_canteen_item.save
				key_split=key.split("_")
				@timeformat = MgSchool.find(session[:current_user_school_id])
				@food_canteen_item.update(:mg_food_item_id=>value, :mg_canteen_id=>@food_item.id, :mg_day_id=>key_split[0], :mg_meal_category_id=>key_split[1])
			end
    		startDateFmt = Date.strptime(params[:canteen_managements][:start_date],@timeformat.date_format)
    		endDateFmt = Date.strptime(params[:canteen_managements][:end_date],@timeformat.date_format)
			@food_item.update(:end_date=>endDateFmt ,:start_date=>startDateFmt)
		end
		redirect_to '/canteen_managements/menu'
	end

	def edit_menu
		@canteen=MgCanteen.find_by(:id=>params[:id])
		@canteenMeal=MgCanteenMeal.where(:is_deleted=>0, :mg_canteen_id=>params[:id])
	end


	def update_menu
		@canteen_data=MgCanteen.find_by(:id=>params[:id])
    puts "0000000000000000000000000000000000000000000000000000000000000"
    puts params[:status]
    puts "0000000000000000000000000000000000000000000000000000000000000"
    # puts asdadas
    if params[:status].present? 
        @canteen_data.update(:status=>params[:status])
    end
		@timeformat = MgSchool.find(session[:current_user_school_id])
		if @canteen_data.update(:updated_by=> session[:user_id],:name=>params[:canteen][:name], :start_date=>params[:canteen][:start_date], :end_date=>params[:canteen][:end_date])
			startDateFmt = Date.strptime(params[:canteen][:start_date],@timeformat.date_format)
    		endDateFmt = Date.strptime(params[:canteen][:end_date],@timeformat.date_format)
			@canteen_data.update(:end_date=>endDateFmt ,:start_date=>startDateFmt)
		end
		#==============================================================================================================
		@canteen_data=MgCanteenMeal.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_canteen_id=>params[:id])
			#=======================================
		if @canteen_data.count==0
			params[:mg_food_item_id].each_with_index do |data, index|
				str=data.to_s
				key= str.slice(2, 3)
				key_split=key.split("_")
				params[:mg_food_item_id][key].each_with_index do |value|
					@food_canteen_item=MgCanteenMeal.new(new_canteen_update_create)
					@food_canteen_item.save
					key_split=key.split("_")
					@timeformat = MgSchool.find(session[:current_user_school_id])
					@food_canteen_item.update(:mg_food_item_id=>value, :mg_canteen_id=>params[:id], :mg_day_id=>key_split[0], :mg_meal_category_id=>key_split[1])
				end
			end
		else
			# ===================================else========================
			@data_presence_delete=MgCanteenMeal.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_canteen_id=>params[:id])
			@data_presence_delete.each do |is_deleted_data|
				is_deleted_data.update(:is_deleted=>1)
			end
					# puts asdasd	
			params[:mg_food_item_id].each_with_index do |data, index|
				str=data.to_s
				key= str.slice(2, 3)
				key_split=key.split("_")
				params[:mg_food_item_id][key].each_with_index do |value|
					@data_presence=MgCanteenMeal.where(:mg_school_id=>session[:current_user_school_id], :mg_food_item_id=>value, :mg_canteen_id=>params[:id], :mg_day_id=>key_split[0], :mg_meal_category_id=>key_split[1])
					if @data_presence.count==0
						@food_canteen_item=MgCanteenMeal.new(new_canteen_update_create)
						@food_canteen_item.save
						key_split=key.split("_")
						@timeformat = MgSchool.find(session[:current_user_school_id])
						@food_canteen_item.update(:mg_food_item_id=>value, :mg_canteen_id=>params[:id], :mg_day_id=>key_split[0], :mg_meal_category_id=>key_split[1])
					else
						@data_presence[0].update(:is_deleted=>0)
					end
				end
			end
			#======================================end=======================			
		end
		#===========================================
		redirect_to '/canteen_managements/menu'
	end

	def delete_menu
		@canteen_data=MgCanteen.find_by(:id=>params[:id])
		@canteen_data.update(:is_deleted=>1)
		@canteen_data_delete=MgCanteenMeal.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_canteen_id=>params[:id])
		@canteen_data_delete.each do |is_deleted_data|
			is_deleted_data.update(:is_deleted=>1)
		end
		redirect_to :back
	end


	def show_menu
		@canteen=MgCanteen.find_by(:id=>params[:id])
		@canteenMeal=MgCanteenMeal.where(:is_deleted=>0, :mg_canteen_id=>params[:id])
	end


    def canteen_manager
        @canteen_manager=MgUser.where(:user_type=>"canteen_manager",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end

    def change_canteen_manager_password
    	@canteen_manager=MgUser.find(params[:id])
    	render :layout=>false
    end

    def delete_canteen_manager
    	canteen_manager=MgUser.find_by(:id=>params[:id])
    	canteen_manager.update(:is_deleted=>1,:updated_by=>session[:user_id])
    	redirect_to :back
  	end

  	def edit_canteen_manager
    	@action='edit'
    	@canteen_manager=MgUser.find_by(:id=>params[:id])
    	render :layout=>false
  	end

  	def new_canteen_manager
  		@action='new'
    	@canteen_manager=MgUser.new
    	render :layout=>false
  	end

  	def create_canteen_manager
    array=[]
    MgUser.transaction do
      school=MgSchool.find_by(:id=>session[:current_user_school_id])
      user=MgUser.new(canteen_manager_params)
      user_name_with_subdomain=school.subdomain + params[:canteen_manager][:user_name]
      user.save
      array.push(user.update(:user_name=>user_name_with_subdomain))
      role=MgRole.find_by(:role_name=>"canteen_manager")
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

  def update_canteen_manager
    canteen_manager=MgUser.find_by(:id=>params[:id])
    school=MgSchool.find_by(:id=>session[:current_user_school_id])
    user_name_with_domain=school.subdomain + params[:canteen_manager][:user_name]
    canteen_manager.update(:user_name=>user_name_with_domain)
    flash[:notice]="Successfully Updated"
    redirect_to :back
  end

  def canteen_manager_change_password
    user_id=params[:canteen_manager_change_password][:user_id]
    @user=MgUser.where(:id =>user_id)
    new_password = params[:canteen_manager_change_password][:new_password] 
    re_new_password =  params[:canteen_manager_change_password][:re_type_password] 
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

  def change_password_by_canteen_manager
    is_doctor=false
    user_id=params[:canteen_manager][:user_id]
    @user=MgUser.where(:id =>user_id)
    user_name = MgUser.where(:id =>user_id).pluck(:user_name)
    @bool=@user.authenticate(user_name, params[:canteen_manager][:name])
    if  @bool==nil
      flash[:notice] = "Please enter correct password !"
      is_doctor=true
    else
      new_password = params[:canteen_manager][:new_password] 
      re_new_password =  params[:canteen_manager][:re_type_password] 
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
    redirect_to :action => "canteen_manager_detail"
  end

  def healthcare_admin_detail
    @healthcare_admin=MgUser.find_by(:id=>session[:user_id])
  end


  def account
    @account=MgCanteenAmountTransaction.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)
  end


  def account_new
       # account_transaction=MgAccountTransaction.add_transaction(from_account_id,to_account_id,amount,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
       # account_transaction.save
       # central_account_transaction=MgCentralAccountTransaction.send_transaction(from_account_id,to_account_id,amount,for_module,particular_id,transaction_type,amount_transfer_type,session[:current_user_school_id],session[:user_id],session[:user_id])
       # central_account_transaction.save
       # redirect_to :action => "account"
      render :layout=>false

  end


  def account_edit
    @account=MgCanteenAmountTransaction.find_by(:id=>params[:id])
    if @account.is_central==true
      @account_data_id='central'
    elsif @account.is_account==true
      @account_data_id=MgAccountTransaction.where(:for_module=>'canteen_managements',:mg_particular_id=>@account.id).pluck(:mg_to_account_id)
      # @account_data_id=MgAccount.
    end
    render :layout=>false
  end


  def account_create
    amount=params[:canteen_managements][:amount]
    if params[:canteen_managements][:mg_account_id]=='central'
        to_account_id=params[:canteen_managements][:mg_account_id]
        canteen_amount_transaction=MgCanteenAmountTransaction.new
        canteen_amount_transaction.is_central=true
        canteen_amount_transaction.amount=amount
        canteen_amount_transaction.is_deleted=0
        canteen_amount_transaction.mg_school_id=session[:current_user_school_id]
        canteen_amount_transaction.created_by=session[:user_id]
        canteen_amount_transaction.updated_by=session[:user_id]
        canteen_amount_transaction.save
        central_account_transaction=MgCentralAccountTransaction.send_canteen_transaction(canteen_amount_transaction.id,to_account_id,amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        central_account_transaction.save
    else
        to_account_id=params[:canteen_managements][:mg_account_id]
        canteen_amount_transaction=MgCanteenAmountTransaction.new
        canteen_amount_transaction.is_account=true
        canteen_amount_transaction.amount=amount
        canteen_amount_transaction.is_deleted=0
        canteen_amount_transaction.mg_school_id=session[:current_user_school_id]
        canteen_amount_transaction.created_by=session[:user_id]
        canteen_amount_transaction.updated_by=session[:user_id]
        canteen_amount_transaction.save
        account_transaction=MgAccountTransaction.add_canteen_transaction(canteen_amount_transaction.id,to_account_id,amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        account_transaction.save
    end
    redirect_to :action => "account"
  end


  def account_update
    canteen_amount_transaction=MgCanteenAmountTransaction.find_by(:id=>params[:id])
    amount=params[:canteen_managements][:amount]
    to_account_id=params[:previous_account_id]
    if params[:previous_account_id]=='central'
        canteen_amount_transaction.update(:amount=>amount,:updated_by=>session[:user_id])
        central_account_transaction_data=MgCentralAccountTransaction.where(:amount_transfer_type=>"credited",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:for_module=>"canteen_managements",:mg_particular_id=>params[:id])
        temp_credited=0
        central_account_transaction_data.each do |catad|
          temp_credited=temp_credited+catad.try(:amount)
        end
        central_account_transaction_data_debited=MgCentralAccountTransaction.where(:amount_transfer_type=>"debited",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:for_module=>"canteen_managements",:mg_particular_id=>params[:id])
        temp_debited=0
        central_account_transaction_data_debited.each do |catad|
          temp_debited=temp_debited+catad.try(:amount)
        end
        temp=temp_credited-temp_debited
        if temp>params[:canteen_managements][:amount].to_i
          credited_amount=temp-params[:canteen_managements][:amount].to_i
        # =============================credited starts===============================================?
        amount_transfer_type="debited"
        central_account_transaction=MgCentralAccountTransaction.send_canteen_updated_transaction(amount_transfer_type,canteen_amount_transaction.id,to_account_id,credited_amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        central_account_transaction.save
        # =============================credited ends=========================================================
        elsif temp<params[:canteen_managements][:amount].to_i
          debited_amount=params[:canteen_managements][:amount].to_i-temp
          # ===========================debited starts======================================================?
        amount_transfer_type="credited"
        central_account_transaction=MgCentralAccountTransaction.send_canteen_updated_transaction(amount_transfer_type,canteen_amount_transaction.id,to_account_id,debited_amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        central_account_transaction.save
        # =============================debited ends====================================================
        end
    else
      canteen_amount_transaction.update(:amount=>amount,:updated_by=>session[:user_id])
        to_account_id=params[:previous_account_id]
        account_transaction_data_credited=MgAccountTransaction.where(:amount_transfer_type=>"credited",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:for_module=>"canteen_managements",:mg_particular_id=>params[:id])
        temp_credited=0
        account_transaction_data_credited.each do |atd|
          temp_credited=temp_credited+atd.try(:amount)
        end

        account_transaction_data_debited=MgAccountTransaction.where(:amount_transfer_type=>"debited",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:for_module=>"canteen_managements",:mg_particular_id=>params[:id])
        temp_debited=0
        account_transaction_data_debited.each do |atd|
          temp_debited=temp_debited+atd.try(:amount)
        end

        temp=temp_credited-temp_debited

        if temp>params[:canteen_managements][:amount].to_i
          credited_amount=temp-params[:canteen_managements][:amount].to_i
        # =============================credited starts===============================================?
        amount_transfer_type="debited"
        account_transaction=MgAccountTransaction.add_canteen_updated_transaction(amount_transfer_type,canteen_amount_transaction.id,to_account_id,credited_amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        account_transaction.save
        # =============================credited ends=========================================================
        elsif temp<params[:canteen_managements][:amount].to_i
          debited_amount=params[:canteen_managements][:amount].to_i-temp
          # ===========================debited starts======================================================?
        amount_transfer_type="credited"
        account_transaction=MgAccountTransaction.add_canteen_updated_transaction(amount_transfer_type,canteen_amount_transaction.id,to_account_id,debited_amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        account_transaction.save
        # =============================debited ends====================================================
        end
        # account_transaction=MgAccountTransaction.add_canteen_transaction(canteen_amount_transaction.id,to_account_id,amount,session[:current_user_school_id],session[:user_id],session[:user_id])
        # account_transaction.save
    end
    redirect_to :action => "account"
  end

  def account_delete
    canteen_amount_transaction=MgCanteenAmountTransaction.find_by(:id=>params[:id])
    canteen_amount_transaction.update(:is_deleted=>1,:updated_by=>session[:user_id])
    redirect_to :back    
  end


  def canteen_managements_account_update
  end









  # ===============================================FEES STARTS==========================================


  def canteen_fee_category
   
  end
  def canteen_fee_category_new
    @feesquery=MgBatch.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id]).pluck(:name,:id, :mg_course_id)
  
   render :layout => false
  end

  def canteen_fee_category_create
    @selected_batches = params[:selected_batches]
    @feedetails=MgFeeCategory.new(subject_params)
    @feedetails.item_category_name="Canteen Management"
    @feedetails.save
    settings_data=MgSchool.find_by(:is_deleted=>0,:id=>session[:current_user_school_id])
    settings_data.exam_mg_fee_category_id=@feedetails.id
    settings_data.save
                     @particularData=params[:particulars]
                     
                     for i in 0...@particularData.size
                      @saveParticular=MgParticularType.new()
                      @saveParticular.particular_name=@particularData[i]
                      @saveParticular.mg_fee_category_id=@feedetails.id
                      @saveParticular.is_deleted=0
                      @saveParticular.mg_school_id=session[:current_user_school_id]
                      @saveParticular.save
                     end
   
    redirect_to :action => "canteen_fee_category"

  end

  def canteen_fee_category_show
     @feeCategory = MgFeeCategory.find(params[:id])
    render :layout => false
  end

def canteen_fee_category_edit
  @hostel_fees = MgFeeCategory.find(params[:id])
    
    @mg_batch_list=MgBatch.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id]).pluck(:name,:id, :mg_course_id) 

    @mg_fee_category_batch_list=MgFeeCategoryBatches.where(:mg_fee_id=>params[:id]).pluck(:mg_batch_id,:id)
    @dueFine=MgParticularType.where(:mg_fee_category_id=>params[:id])
    

    render :layout => false 
end

def canteen_fee_category_update
  @feeCategoryObj = MgFeeCategory.find(params[:id])
             
  @updateparticulars=params[:particulars]
  @particulartypeId=params[:particularstype]
                
  for i in 0 ... @updateparticulars.size
    @particulartype=MgParticularType.find_by(:mg_fee_category_id=>params[:id],:id=>@particulartypeId[i])                

  if !(@particulartype.nil?)
    @particulartype.update(:particular_name=>@updateparticulars[i])
  else
     @particular=MgParticularType.new()
     @particular.particular_name=@updateparticulars[i]
     @particular.mg_fee_category_id=params[:id]
     @particular.is_deleted=0
     @particular.mg_school_id=session[:current_user_school_id]
     @particular.save
  end
end

     if @feeCategoryObj.update(subject_params)
       redirect_to :action=>'canteen_fee_category'
     else
       render 'canteen_fee_category_edit'
     end
  end

  def delete_canteen_fee_category
    @fees=MgFeeCategory.find_by_id(params[:id])
    @fees.is_deleted =1
    @fees.save
    @particularType=MgParticularType.where(:mg_fee_category_id=>params[:id])
    @particularType.each do |delete|
      delete.is_deleted=1
      delete.save
    end
    redirect_to :action=>'canteen_fee_category'
  end

def manage_canteen_particulars
  puts "========================================================================================"
  puts params[:id]
  puts "========================================================================================"
  puts session[:feedetails_id]
  puts "========================================================================================"
  # puts qwerty
    if params[:id].nil? 
        @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>session[:feedetails_id]).paginate(page: params[:page], per_page: 5)
      else
        @particular_list=MgFeeParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:fee_category=>params[:id]).paginate(page: params[:page], per_page: 5)
        @fee_category=MgFeeCategory.find(params[:id])
        session[:feedetails_id] = @fee_category.id
      end

  end

  def manage_canteen_particulars_new
    @subjects=MgFeeParticular.new()
    render :layout => false
  end
 
  def manage_canteen_particulars_create
    # puts "6666666666666666666666666666666666666666666666666666666666666666666666666666"
    # puts params
    # puts "6666666666666666666666666666666666666666666666666666666666666666666666666666"
    # # puts asdsada
     @selected_batches1 = params[:selected_batches1]
    @params=params[:selectedStudents]
      for i in 0...@params.size
        @feeParticularObj=MgFeeParticular.new(particular_params) 
        @feeParticularObj.name="Canteen Fee"
        @data=MgStudent.find(@params[i])
        @batchID=@data.mg_batch_id
        @feeParticularObj.mg_batch_id=@batchID
        @feeParticularObj.admission_no= @data.admission_number
        save_account_id(params[:fesses2][:selected_account_id],params[:mg_account_id],@feeParticularObj)
        @feeParticularObj.save
      end

      # =====================================================================================================================
      array=[]
      paid_amount=params[:fesses2][:amount].to_i
      @canteen_bill_details=MgCanteenBillDetail.where(:mg_batch_id=>params[:selected_batches1],:mg_student_id=>params[:selectedStudents],:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        @canteen_bill_details.each do |bill_object|
          if bill_object.balance_amount.to_i>0
            if (paid_amount>0) && (paid_amount>=bill_object.balance_amount.to_i)
              paid_amount=paid_amount-bill_object.balance_amount.to_i
              array.push(bill_object.update(:balance_amount=>0,:updated_by=>session[:user_id]))
            elsif (paid_amount>0) && (paid_amount<=bill_object.balance_amount.to_i)
              net_balance_amount=bill_object.balance_amount.to_i-paid_amount

              paid_amount=paid_amount-bill_object.balance_amount.to_i
              array.push(bill_object.update(:balance_amount=>net_balance_amount,:updated_by=>session[:user_id]))
            end
          end #bill_object
        end #end of @canteen_bill_details.each
      # =====================================================================================================================
  
    redirect_to :action=>'manage_canteen_particulars',:controller=>'canteen_managements',:id=>params[:id]
  end

  def save_account_id(selected_account_id,new_account_id,fees_particular_object)
    if selected_account_id.present?
      if selected_account_id=="central"
        fees_particular_object.is_to_central=1
      else
        fees_particular_object.mg_account_id=selected_account_id
      end
    elsif new_account_id.present?
      if new_account_id=="central"
        fees_particular_object.is_to_central=1
      else
        fees_particular_object.mg_account_id=new_account_id
      end
    end
  end

  def canteen_edit_fee_particular
    @fesses2 = MgFeeParticular.find(params[:id])
    @cceID=Array.new
    @cceID.push(@fesses2.mg_batch_id)
    logger.info @fesses2.inspect
    render :layout => false
  end

  def canteen_update_fee_particular
    @feeParticularObj = MgFeeParticular.find(params[:id])
    @feeParticularParams = update_particular_params
    @params=params[:selectedStudents]
    if(params[:fesses2][:value1]=='All')
      @feeParticularParams[:admission_no] = ''
      @feeParticularParams[:mg_student_category_id] =''
    end
    if(params[:fesses2][:value1]=='demo')
      @feeParticularParams[:admission_no] =  params[:fesses2][:admission_no] 
      @feeParticularParams[:mg_student_category_id] =''
    end
    if(params[:fesses2][:value1]=='demo2')         
      @feeParticularParams[:admission_no] = ''  
      @feeParticularParams[:mg_student_category_id] =params[:fesses2][:mg_student_category_id]
    end
    @feeParticularObj.update(@feeParticularParams)
    redirect_to :action=>'manage_canteen_particulars',:id=>@feeParticularObj.fee_category
  end

  def canteen_destroy_fee_particular
    @feesparticular=MgFeeParticular.find(params[:id])
    @feesparticular.is_deleted =1
    @feesparticular.save
    redirect_to :action=>'manage_canteen_particulars',:id=>@feesparticular.fee_category
  end

  def canteen_fee_schedule
    @fee_collection_list=MgFeeCollection.where(:is_deleted => 0, :mg_school_id=> session[:current_user_school_id],:collection_type=>"canteen_management").paginate(page: params[:page], per_page: 5)
  end

  def canteen_delete_fee_schedule
    @fee_fine_schedule=MgFeeCollection.find_by_id(params[:id])
    @fee_fine_schedule.update(:is_deleted=>1)
    redirect_to :action=>'canteen_fee_schedule'
  end


  # =============================================FEES ENDS==============================================

  private

  def food_item_params
    params.require(:food_items).permit(:quantity,:unit, :brand,:item_name,:price,:category,:description,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def meal_category_params
    params.require(:meal_category).permit(:name,:priority,:description,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end

  def bill_detail_params
    params.require(:bill_detail).permit(:user_type,:mg_batch_id,:mg_student_id,:mg_employee_department_id,:mg_employee_id,:is_deleted,:mg_school_id,:created_by,:updated_by)
  end
  
  def new_menu_create
  		params.require(:canteen_managements).permit(:is_deleted, :mg_school_id, :created_by, :updated_by, :name, :start_date, :end_date)
  end
  def new_canteen_create
  		params.require(:canteen_managements).permit(:is_deleted, :mg_school_id, :created_by, :updated_by)
  end
  def new_canteen_update_create
  		params.require(:canteen).permit(:is_deleted, :mg_school_id, :created_by, :updated_by)
  end

   def canteen_manager_params
    params.require(:canteen_manager).permit(:user_type,:password,:is_deleted,:created_by,:updated_by,:mg_school_id)
  end

    def subject_params
    params.require(:hostel_fees).permit(:name,:description,:is_deleted, :mg_school_id)
  end

   def particular_params
    params.require(:fesses2).permit(:mg_particular_type_id,:description,:fee_category,:is_deleted, :mg_school_id,:amount,
     :admission_no, :mg_student_category_id)
  end

  def update_particular_params
    params.require(:fesses2).permit(:name,:description,:fee_category,:is_deleted, :mg_school_id,:amount, :admission_no, :mg_student_category_id)
  end

end
