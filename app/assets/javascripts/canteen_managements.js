$(document).on("click", ".add-regular-menu-again", function(e){
  // alert("hi");
  var lastRepeatingGroup = $(".canteent-regular-menu-row").last();
  var cloned = lastRepeatingGroup.clone();
  cloned.find("i").removeClass("fa fa-plus-circle");
  cloned.find("a").removeClass("add-regular-menu-again");
  cloned.find("i").addClass("fa fa-minus-circle");
  cloned.find("a").addClass("delete-regular-menu-again");
  cloned.find('.mg-food-item-selec-cls').val("");
  cloned.find('select').val('pending');
  // cloned.find('.canteen-status-cls').val('pending');
  // canteen-status-cls

  var last_ids= lastRepeatingGroup.find('.canteen-status-cls').attr('id')
  var data_arr= last_ids.split("_")
  if (parseInt(data_arr[1]) % 1 === 0)
  {
    var data=parseInt(data_arr[1])
  }else{
    var data_arr= last_ids.split("_")
    var data=parseInt(data_arr[1])
  }

  cloned.insertAfter(lastRepeatingGroup);
  $(".canteen-menu-index-field:visible").each(function(index,element){
    $(this).text(index+1);
    var status_id=data+1
    cloned.find('.canteen-status-cls').attr('id',   "status_" +  status_id);
    cloned.find('.canteen-status-cls').attr('name',   "status"+"["+status_id+"]");
  });
});

$(document).on("click", ".delete-regular-menu-again", function(e){
  $(this).parent().parent(".canteent-regular-menu-row").last().remove();
  $(".canteen-menu-index-field:visible").each(function(index,element){
    $(this).text(index+1);
  });
});


//===============bill details========================

function mgBatchChangeFunction(batch_id){
  $.ajax({
    url: '/canteen_managements/student_details',
    data:{"mg_batch_id":batch_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].admission_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#bill_detail_mg_student_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#bill_detail_mg_student_id").empty().append(apdStr);;
      }
    }
  });
}

function billDetailDepartmentChangeFunction(department_id){
  $.ajax({
    url: '/canteen_managements/employee_details',
    data:{"mg_employee_department_id":department_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].employee_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#bill_detail_mg_employee_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#bill_detail_mg_employee_id").empty().append(apdStr);;
      }
    }
  });
}


//=========================generate bill cloning========================


$(document).on("click","#billDetailsMoreFoodItem",function(){
  var lastRepeatingGroup = $('.bill-detail-row-div-id').last();
  var cloned = lastRepeatingGroup.clone();
  cloned.find('input').val('');
  cloned.find('select').val('');

  var last_ids= lastRepeatingGroup.find('.food-item-record-id').attr('id')
  var data_arr= last_ids.split("_")
  if (parseInt(data_arr[4]) % 1 === 0)
  {
    var data=parseInt(data_arr[4])
  }else{
    var data_arr= last_ids.split("_")
    var data=parseInt(data_arr[4])
  }


  cloned.insertAfter( lastRepeatingGroup );

  $(".incremented-field-text-cls:visible").each(function(index,element){
      $(this).text(index+1);
      var object_id=data+1
      cloned.find('.food-item-record-id').attr('id',   "mg_food_item_id_" +  object_id);
      cloned.find('.food-item-record-id').attr('name',   "mg_food_item_id"+"["+object_id+"]");

      cloned.find('.food-item-record-id2').attr('id',   "quantity_" +  object_id);
      cloned.find('.food-item-record-id2').attr('name',   "quantity"+"["+object_id+"]");

      cloned.find('.food-item-record-id4').attr('id',   "unit_quantity" +  object_id);
      cloned.find('.food-item-record-id4').attr('name',   "unit_quantity"+"["+object_id+"]");

      cloned.find('.food-item-record-id3').attr('id',   "total_price_" +  object_id);
      cloned.find('.food-item-record-id3').attr('name',   "total_price"+"["+object_id+"]");
    });
  }); 


$(document).on("click", ".remove-bill-details-cls", function(e){
  var total = $('.bill-detail-row-div-id').length
  if(total!=1){
    $(this).parent('td').parent('.bill-detail-row-div-id').remove(); 
  }
  $(".incremented-field-text-cls:visible").each(function(index,element){
    $(this).text(index+1);
  });
  //=============total amount=================
  total_amount=0
  $(".remove-cls-for-total-amount").each( function( index, element ){
    var total_price = $(this).val();
    if(total_price!=''){
      total_amount=parseInt(total_amount)+parseInt(total_price)
    };
  });
  $(".calculate-total-amount").val(total_amount);
  //==============total amount=================
  $(".balance-amount-cls").val('');
  $(".paid-amount-cls").val('');
});



  //=============search by option===================================

  function mgBatchChangeFunction(batch_id){
  $.ajax({
    url: '/canteen_managements/student_details',
    data:{"mg_batch_id":batch_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].admission_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#bill_detail_mg_student_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#bill_detail_mg_student_id").empty().append(apdStr);;
      }
    }
  });
}


//========searching start================


$(document).on("change","#bill_detail_user_type",function(){
  var user_type=$("#bill_detail_user_type").val();
  if(user_type=="employee"){

    $("#billDetailStudentDivId").hide();
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByStudentIdDivID").hide();
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();

    $("#billDetailEmployeeDivId").show();
  }else{
    $("#billDetailEmployeeDivId").hide();
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByStudentIdDivID").hide();
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();

    $("#billDetailStudentDivId").show();
  }
});

$(document).on("change","#user_type_option",function(){
  var search_by_option=$("#user_type_option").val();
  if(search_by_option=="student_id"){
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();
    $("#billDetailStudentDivId").hide();
    $("#billDetailEmployeeDivId").hide();

    $("#billDetailByStudentIdDivID").show();
  }else if (search_by_option=="employee_id"){
    $("#billDetailByStudentIdDivID").hide();
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();
    $("#billDetailStudentDivId").hide();
    $("#billDetailEmployeeDivId").hide();

    $("#billDetailByEmployeeIDDivID").show();
  }else if (search_by_option=="student_name"){
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByStudentIdDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();
    $("#billDetailStudentDivId").hide();
    $("#billDetailEmployeeDivId").hide();

    $("#billDetailByStudentNameDivID").show();
  }else if (search_by_option=="employee_name"){
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByStudentIdDivID").hide();
    $("#billDetailStudentDivId").hide();
    $("#billDetailEmployeeDivId").hide();

    $("#billDetailByEmployeeNameDivID").show();
  }
});

$(document).on("keyup",".search-student-ids-cls",function(){
  var student_id=$(this).val();
  $.ajax({
    url: '/canteen_managements/search_student_employee_details',
    data:{"search_by":"search_by_student_id","student_id":student_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].admission_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#student_name_list").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#student_name_list").empty().append(apdStr);;
      }
    }
  });
});


$(document).on("keyup",".search-employee-ids-cls",function(){
  var employee_id=$(this).val();
  $.ajax({
    url: '/canteen_managements/search_student_employee_details',
    data:{"search_by":"search_by_employee_id","employee_id":employee_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].employee_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#employee_name_list").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#employee_name_list").empty().append(apdStr);;
      }
    }
  });
});

$(document).on("keyup",".search-student-name-cls",function(){
  var student_name=$(this).val();
  $.ajax({
    url: '/canteen_managements/search_student_employee_details',
    data:{"search_by":"search_by_student_name","student_name":student_name},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].admission_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#student_id_list").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#student_id_list").empty().append(apdStr);;
      }
    }
  });
});

$(document).on("keyup",".search-employee-name-cls",function(){
  var employee_name=$(this).val();
  $.ajax({
    url: '/canteen_managements/search_student_employee_details',
    data:{"search_by":"search_by_employee_name","employee_name":employee_name},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].employee_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#employee_id_list").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#employee_id_list").empty().append(apdStr);;
      }
    }
  });
});


$(document).on("click","#bill_detail_checkup_for_search_by_user",function(){
  if($(this).is(":checked")) {
    $("#billBySelectUserDivId").find('select').val('');
    $("#billDetailStudentDivId").find('select').val('');

    $("#billDetailStudentDivId").hide();
    $("#billBySelectUserDivId").hide();
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();
    $("#billDetailEmployeeDivId").hide();

    $("#billBySearchUserDivId").show();
  }
});

$(document).on("click","#bill_detail_checkup_for_select_user",function(){
  if($(this).is(":checked")) {
    $("#billBySearchUserDivId").find('select').val('');

    $("#billDetailByStudentIdDivID").hide();
    $("#billDetailByStudentNameDivID").hide();
    $("#billDetailByEmployeeIDDivID").hide();
    $("#billDetailByEmployeeNameDivID").hide();
    $("#billBySearchUserDivId").hide();
    $("#billDetailEmployeeDivId").hide();
    
    $("#billBySelectUserDivId").show();
    $("#billDetailStudentDivId").show();
  }
});

//========searching end================



//====total amount functionality=======

$(document).on("change",".food-quantity-cls",function(){
  var food_item_id=$(this).parent("td").siblings(".food-items-cls").find("select").val();
  var quantity=$(this).val();
  var this_val=$(this);
  var urlLink="/canteen_managements/total_price";
  if(quantity!='' && food_item_id!=''){
    $.ajax({
      url: urlLink,
      cache:false,
      data:{"food_item_id":food_item_id,"food_quantity":quantity},
      success: function(data){
        //==================today==============
        var total_sum=parseInt(data[0]["price"])*parseInt(quantity)
        var unit_quantity=parseInt(data[0]["quantity"])*parseInt(quantity)
        this_val.parent("td").siblings(".total-unit-quantity-cls").find(".food-unit-quantity-cls").val(unit_quantity);
        //==================today==============
        this_val.parent("td").siblings(".total-price-cls").find(".food-item-record-id3").val(total_sum);
        total_amount=0
        $(".remove-cls-for-total-amount").each( function( index, element ){
          var total_price = $(this).val();
          if(total_price!=''){
            total_amount=parseInt(total_amount)+parseInt(total_price)
          };
        });
        //==================Amount To Be Paid ========================
        var total_paid_amunt=$("#total_previous_balance_").val();
        var pavable_amount=parseInt(total_amount)+parseInt(total_paid_amunt)
        $("#total_sum_amount_").val(pavable_amount);
        //==================Amount To Be Paid ========================

        $(".calculate-total-amount").val(total_amount);
        var paid_value=$(".calculate-total-amount").val();
        if(paid_value!='' && paid_value>0){
          $(".paid-amount-cls").attr("readonly", false); 
          $(".paid-amount-cls").val('');
          $(".balance-amount-cls").val('');
        }else{
          $(".paid-amount-cls").attr("readonly", true); 
          $(".paid-amount-cls").val('');
          $(".balance-amount-cls").val('');
        }
      }
    });
  }else{
    this_val.parent("td").siblings(".total-unit-quantity-cls").find(".food-unit-quantity-cls").val(0);
    this_val.parent("td").siblings(".total-price-cls").find(".food-item-record-id3").val(0);
    total_amount=0
    $(".remove-cls-for-total-amount").each( function( index, element ){
      var total_price = $(this).val();
      if(total_price!=''){
        total_amount=parseInt(total_amount)+parseInt(total_price)
      };
    });
    $(".calculate-total-amount").val(total_amount);
     //==================Amount To Be Paid ========================
      var total_paid_amunt=$("#total_previous_balance_").val();
      var pavable_amount=parseInt(total_amount)+parseInt(total_paid_amunt)
      $("#total_sum_amount_").val(pavable_amount);
      //==================Amount To Be Paid ========================
    var paid_value=$(".calculate-total-amount").val();
    if(paid_value!='' && paid_value>0){
      $(".paid-amount-cls").attr("readonly", false);
      $(".paid-amount-cls").val('');
      $(".balance-amount-cls").val('');
    }else{
      $(".paid-amount-cls").attr("readonly", true); 
      $(".paid-amount-cls").val('');
      $(".balance-amount-cls").val('');
    }
  }
});


function foodItemTypeFunction(food_value,that){
  if(food_value!=''){
    array=[];
    var text_val= parseInt($(that).parent("td").siblings("td").text());

    $(".bill-detail-row-div-id").each( function( index, element ){
      var select_val = $(this).children("td").find("select").val();
      if((index+1)!=text_val){
        array.push(select_val);
      }
    });
    if(array.indexOf(food_value) > -1){
      alert("Already selected please select other!");
      $(that).parent("td").siblings(".total-unit-quantity-cls").find(".food-unit-quantity-cls").val(0);
      $(that).parent("td").siblings(".total-price-cls").find(".food-item-record-id3").val(0);
      $(that).val('');
      total_amount=0
      $(".remove-cls-for-total-amount").each( function( index, element ){
        var total_price = $(this).val();
        if(total_price!=''){
          total_amount=parseInt(total_amount)+parseInt(total_price)
        };
      });
      $(".calculate-total-amount").val(total_amount);
      //==================Amount To Be Paid ========================
      var total_paid_amunt=$("#total_previous_balance_").val();
      var pavable_amount=parseInt(total_amount)+parseInt(total_paid_amunt)
      $("#total_sum_amount_").val(pavable_amount);
      //==================Amount To Be Paid ========================
    }else{
      var quantity=$(that).parent("td").siblings(".quantites-cls").find(".food-quantity-cls").val();
      var urlLink="/canteen_managements/total_price";
      if(quantity!='' && food_value!=''){
        $.ajax({
          url: urlLink,
          cache:false,
          data:{"food_item_id":food_value,"food_quantity":quantity},
          success: function(data){
            //==================today==============
            var total_sum=parseInt(data[0]["price"])*parseInt(quantity)
            var unit_quantity=parseInt(data[0]["quantity"])*parseInt(quantity)
            $(that).parent("td").siblings(".total-unit-quantity-cls").find(".food-unit-quantity-cls").val(unit_quantity);
            //==================today==============
            $(that).parent("td").siblings(".total-price-cls").find(".food-item-record-id3").val(total_sum);

            total_amount=0
            $(".remove-cls-for-total-amount").each( function( index, element ){
              var total_price = $(this).val();
              if(total_price!=''){
                total_amount=parseInt(total_amount)+parseInt(total_price)
              };
            });
            $(".calculate-total-amount").val(total_amount);
              //==================Amount To Be Paid ========================
              var total_paid_amunt=$("#total_previous_balance_").val();
              var pavable_amount=parseInt(total_amount)+parseInt(total_paid_amunt)
              $("#total_sum_amount_").val(pavable_amount);
              //==================Amount To Be Paid ========================

            var paid_value=$(".calculate-total-amount").val();
            if(paid_value!='' && paid_value>0){
              $(".paid-amount-cls").attr("readonly", false);
              $(".paid-amount-cls").val('');
              $(".balance-amount-cls").val('');
            }else{
              $(".paid-amount-cls").attr("readonly", true); 
              $(".paid-amount-cls").val('');
              $(".balance-amount-cls").val('');
            }
          }
        });
      };
    }
  }else{
    $(that).parent("td").siblings(".total-unit-quantity-cls").find(".food-unit-quantity-cls").val(0);
    $(that).parent("td").siblings(".total-price-cls").find(".food-item-record-id3").val(0);

    total_amount=0
    $(".remove-cls-for-total-amount").each( function( index, element ){
      var total_price = $(this).val();
      if(total_price!=''){
        total_amount=parseInt(total_amount)+parseInt(total_price)
      };
    });
    $(".calculate-total-amount").val(total_amount);
    //==================Amount To Be Paid ========================
    var total_paid_amunt=$("#total_previous_balance_").val();
    var pavable_amount=parseInt(total_amount)+parseInt(total_paid_amunt)
    $("#total_sum_amount_").val(pavable_amount);
    //==================Amount To Be Paid ========================

    var paid_value=$(".calculate-total-amount").val();
    if(paid_value!='' && paid_value>0){
      $(".paid-amount-cls").attr("readonly", false); 
      $(".paid-amount-cls").val('');
      $(".balance-amount-cls").val('');

    }else{
      $(".paid-amount-cls").attr("readonly", true); 
      $(".paid-amount-cls").val('');
      $(".balance-amount-cls").val('');
    }
  }
}


$(document).on("change",".paid-amount-cls",function(){
  var total_amount=$(".total-amount-cls").val();
  var old_wallet_amount=$("#hidden_wallet_amount").val();
  var paying_amount=$(this).val();
  if(!isNaN(paying_amount)){
    if(parseInt(paying_amount)<=parseInt(total_amount)){
      var balance_amount=parseInt(total_amount)-parseInt(paying_amount)
      $(".balance-amount-cls").val(balance_amount);
      $(".wallet-amount-cls").val(old_wallet_amount);
    }else if(parseInt(paying_amount)>parseInt(total_amount)){
      //alert("Paying amount should be less than total amount")
      //========================================
      $(".balance-amount-cls").val(0);
      var wallet_amount=parseInt(paying_amount)-parseInt(total_amount)
      var new_wallet_amount=parseInt(wallet_amount)+parseInt(old_wallet_amount)
      $(".wallet-amount-cls").val(new_wallet_amount);
      //========================================
      return false;
    }else{
      $(".wallet-amount-cls").val(old_wallet_amount);
    }
  }else{
    $(".wallet-amount-cls").val(old_wallet_amount);
  }
});


$(document).on("change","#pay_balance_amount_user_type",function(){
  var user_type=$("#pay_balance_amount_user_type").val();
  if(user_type=="employee"){
    $("#billDetailStudentDivId").hide();
    $("#billDetailEmployeeDivId").show();
  }else{
    $("#billDetailEmployeeDivId").hide();
    $("#billDetailStudentDivId").show();
  }
});

function studentPaymentFunction(batch_id){
  $("#balanceDetailsList").empty();
  $.ajax({
    url: '/canteen_managements/student_details',
    data:{"mg_batch_id":batch_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].admission_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#pay_balance_amount_mg_student_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#pay_balance_amount_mg_student_id").empty().append(apdStr);;
      }
    }
  });
}

function employeePaymentFunction(department_id){
  $("#balanceDetailsList").empty();
  $.ajax({
    url: '/canteen_managements/employee_details',
    data:{"mg_employee_department_id":department_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].employee_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#pay_balance_amount_mg_employee_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#pay_balance_amount_mg_employee_id").empty().append(apdStr);;
      }
    }
  });
}


function studentPaymentDetailFunction(){
  var user_type = $("#pay_balance_amount_user_type").val()
  var mg_batch_id = $("#pay_balance_amount_mg_batch_id").val()
  var mg_student_id = $("#pay_balance_amount_mg_student_id").val()
  var mg_employee_department_id = $("#pay_balance_amount_mg_employee_department_id").val()
  var mg_employee_id = $("#pay_balance_amount_mg_employee_id").val()
  $("#balanceDetailsList").empty();
  if($("#payBalanceAmountFormID").valid()){
    $.ajax({
      url: '/canteen_managements/balance_details',
      data:{"user_type":user_type,"mg_batch_id":mg_batch_id,"mg_student_id":mg_student_id,"mg_employee_department_id":mg_employee_department_id,"mg_employee_id":mg_employee_id},
      cache: false,
      success: function(html){
        $("#balanceDetailsList").html(html);
      }
    });
  }
}


$(document).on("change",".total-paid-amount-cls",function(){
  var paid_amount=$(this).val();
  var balance_amount=$(".total-balance-amount-cls").val();
  if(parseInt(paid_amount)>parseInt(balance_amount)){
    // alert("Paid amount should be less than total amount");
    // $(this).val('');
  }else{
    $(".remaining-balance-amount-cls").val(parseInt(balance_amount)-parseInt(paid_amount));
  }
});


function studentAndEmployeePaymentDetail(){
  var user_type = $("#pay_balance_amount_user_type").val()
  var mg_batch_id = $("#pay_balance_amount_mg_batch_id").val()
  var mg_student_id = $("#pay_balance_amount_mg_student_id").val()
  var mg_employee_department_id = $("#pay_balance_amount_mg_employee_department_id").val()
  var mg_employee_id = $("#pay_balance_amount_mg_employee_id").val()
  $("#showBalanceDetailsList").empty();
  if($("#payBalanceAmountFormID").valid()){
    $.ajax({
      url: '/canteen_managements/show_balance_details',
      data:{"user_type":user_type,"mg_batch_id":mg_batch_id,"mg_student_id":mg_student_id,"mg_employee_department_id":mg_employee_department_id,"mg_employee_id":mg_employee_id},
      cache: false,
      success: function(html){
        $("#showBalanceDetailsList").html(html);
      }
    });
  }
}



$(document).on("click",".generate-canteen-bill-details-pdf",function(){
  // var res = $("#generateReportFormID").valid();
  var pdfID = $(this).attr('id');
  var id = pdfID.split("-");
  // var url="/canteen_managements/healh_card_pdf?mg_student_id="+student_id+"&mg_batch_id="+batch_id+"&mg_employee_id="+employee_id+"&mg_employee_department_id="+emp_department_id+"&format=pdf&target=_blank";
  var url="/canteen_managements/bill_detail_pdf/?id="+id+"&format=pdf&target=_blank";
  window.open(url, '_blank');
});