$(document).on("click", "#addMoreVaccinationIDS", function(e){
  var row_length = $('.new-row-for-vaccination').length
  var txt= $(".required-incremented-field:visible").text();
  if(txt=='' && row_length==1){
    $(".add-vaccination-div-class").show();
  }else{
    var dateFormatStr =  getJsDateFormat();

    var lastRepeatingGroup = $('.new-row-for-vaccination').last();
    var cloned = lastRepeatingGroup.clone();
    //cloned.find(".vaccination-remove-details").removeAttr('id');
    cloned.find(".vaccination-remove-details").attr("id",""); 
   
    cloned.find('input').val('');
    cloned.insertAfter( lastRepeatingGroup );
     

    var ids= lastRepeatingGroup.find('.text-value-cls1').attr('id')
    var data_arr= ids.split("_")
      
    if (parseInt(data_arr[1]) % 1 === 0)
    {
      var data=parseInt(data_arr[1])
    }else{
      var data_arr= ids.split("_")
      var demo= data_arr[0].split("[")
      var demo1= demo[1].split("]")
      var data=parseInt(demo1[0])
    }
    $(".required-incremented-field:visible").each(function(index,element){
      $(this).text(index+1);
      var data1=data
      cloned.find('.text-value-cls1').attr('id',   "immunization_" +  data1);
      cloned.find('.text-value-cls1').attr('name',   "immunization[]");

      cloned.find('.text-value-cls2').attr('id',   "age_recommended_" +  data1);
      cloned.find('.text-value-cls2').attr('name',   "age_recommended[]");
     
      cloned.find('.text-value-cls3').attr('id',   "vaccination_due_date_" +  data1);
      cloned.find('.text-value-cls3').attr('name',   "vaccination_due_date[]");

      cloned.find('.text-value-cls4').attr('id',   "vaccination_date_" +  data1);
      cloned.find('.text-value-cls4').attr('name',   "vaccination_date[]");

      data=data1+1

      var text_value = $(this).parent(".required-incremented-field-class").siblings(".date-picker-cls").children(".text-value-cls3");
      var text_value2 = $(this).parent(".required-incremented-field-class").siblings(".date-picker-cls").children(".text-value-cls4");
      text_value.removeClass('hasDatepicker');
      text_value2.removeClass('hasDatepicker');
      var dateFormatStr =  getJsDateFormat();
      text_value.datepicker({  ochangeMonth: true,changeYear: true,yearRange: "-100:+0", dateFormat: dateFormatStr});
      text_value2.datepicker({  ochangeMonth: true,changeYear: true,yearRange: "-100:+0", dateFormat: dateFormatStr});
    });
  }

  return false;
}); 

$(document).on("click", ".vaccination-remove-details", function(e){
  var total = $('.vaccination-remove-details').length
  var particular_id = $(this).attr('id');
  var id = particular_id.split("-");
  var vaccination_record="vaccination";
  //alert("id="+id[0]+"total="+total);
  if(id[0]!=''){
    deleteParticular(id[0],vaccination_record);
  }else{
    if(total==1){
      $(this).parents(".new-row-for-vaccination").children().find(".text-value-cls1").val('');
      $(".add-vaccination-div-class").hide();
    }else{
      $(this).parent('td').parent().remove();   
    }
    
    $(".required-incremented-field:visible").each(function(index,element){
      $(this).text(index+1);
    });
  }
});



function deleteParticular(id,record){
  var urlLink = "/healthcare/immunization_particular/"+id;
  $.ajax({
    url: urlLink ,
    cache: false,
    data: {mg_vaccination_detail_id: id,immunization_record:record},
    success: function(data){
      console.log(data);
      selectVaccinationListFromStudent(data);
    }
  });
}





//booster doses

$(document).on("click", "#addMoreBossterDosesDetailsID", function(e){
  var row_length = $('.boster-doses-new-row').length
  var txt= $(".booster-incremented-field:visible").text();
  if(txt=='' && row_length==1){
    $(".add-booster-div-class").show();
  }else{

    var lastRepeatingGroup = $('.boster-doses-new-row').last();
    var cloned = lastRepeatingGroup.clone();
   
    cloned.find(".booster-doses-remove-details").attr("id",""); 
    cloned.find('input').val('');
    cloned.insertAfter( lastRepeatingGroup );

    var last_ids= lastRepeatingGroup.find('.booster-text-value-cls1').attr('id')
    var data_arr= last_ids.split("_")
    if (parseInt(data_arr[2]) % 1 === 0)
    {
      var data=parseInt(data_arr[2])
    }else{
      var data_arr= last_ids.split("_")
      var demo= data_arr[1].split("[")
      var demo1= demo[1].split("]")
      var data=parseInt(demo1[0])
    }
    $(".booster-incremented-field:visible").each(function(index,element){
      $(this).text(index+1);
      var data1=data
      cloned.find('.booster-text-value-cls1').attr('id',   "booster_name_" +  data1);
      cloned.find('.booster-text-value-cls1').attr('name',   "booster_name[]");

      cloned.find('.booster-text-value-cls2').attr('id',   "booster_frequency_" +  data1);
      cloned.find('.booster-text-value-cls2').attr('name',   "booster_frequency[]");
     
      cloned.find('.booster-text-value-cls3').attr('id',   "booster_date_" +  data1);
      cloned.find('.booster-text-value-cls3').attr('name',   "booster_date[]");

      cloned.find('.booster-text-value-cls4').attr('id',   "booster_dose_due_date" +  data1);
      cloned.find('.booster-text-value-cls4').attr('name',   "booster_dose_due_date[]");

      data=data1+1

      var text_value = $(this).parent(".booster-incremented-field-class").siblings(".date-picker-cls").children(".booster-text-value-cls3");
      text_value.removeClass('hasDatepicker');
      var dateFormatStr =  getJsDateFormat();
      text_value.datepicker({  ochangeMonth: true,changeYear: true,yearRange: "-100:+0", dateFormat: dateFormatStr});
    });
  }
  return false;
}); 


$(document).on("click", ".booster-doses-remove-details", function(e){
  var total = $('.booster-doses-remove-details').length

  var particular_id = $(this).attr('id');
  var id = particular_id.split("-");
  //alert("id="+id[0]+"total="+total);
  var booster_doses = "booster_doses";
  if(id[0]!=''){
    deleteParticular(id[0],booster_doses);
  }else{
    if(total==1){
      $(this).parents(".boster-doses-new-row").children().find(".booster-text-value-cls1").val('');
      $(".add-booster-div-class").hide();
    }else{
      $(this).parent('td').parent().remove();   
    }
    $(".booster-incremented-field:visible:visible").each(function(index,element){
      $(this).text(index+1);
    });
  }
});

$(document).on("click", ".delete-bed-details-btn", function(e){
  var myID =$(this).attr('id');
  var Id=myID.split("-");
  var urlLink = "/healthcare/delete_bed_detail/"+Id[0];
  var result = confirm("Are you sure to delete?");
  if(result){
    window.location=urlLink;
  }
});


function healTestHistoryFunction(){
    //student_id
    var student_id = $("#mg_student_id").val();
    var batch_id = $("#mg_batch_id").val();
    var emp_deptartment_id = $("#mg_employee_department_id").val();
    var employee_id = $("#mg_employee_id").val();

    var checkup_schedule_id = $("#mg_check_up_schedule_id").val();
    var check_type_id = $("#health_test_mg_check_up_type_id").val();
    var urlLink = "/healthcare/health_test_history";
    if(student_id!='' || employee_id!='' ){
      $.ajax({
        url: urlLink,
        cache: false,
        data: {check_type_id:check_type_id,mg_batch_id:batch_id,mg_student_id:student_id,mg_check_up_schedule_id:checkup_schedule_id,mg_employee_department_id:emp_deptartment_id,mg_employee_id:employee_id},
        success: function(data){
          $("#helatestHistoryShowId").show();
          $('#healthTestHistoryDivID').html(data)
        }
      })
    }else{
      $('#healthTestHistoryDivID').empty();
      $("#helatestHistoryShowId").hide();
    }
  }




  function abcd(){
    $(".immunization-due-date-cls").datepicker({changeMonth: true,changeYear: true,yearRange: "-100:+0", dateFormat: dateFormatStr});
  }
$(document).on("click", ".add-same-booster-again", function(e){
var value=$(this).prop("id");
  var eleClass="add-same-booster-again-"+value;
  var row_length = $(".add-same-booster-again-"+value).length
  if (row_length>0)
  {
      var lastRepeatingGroup = $(this).parent().parent(".boster-doses-new-inline-row").last();
      var cloned = lastRepeatingGroup.clone();
      cloned.find("a").removeClass("fa fa-plus-circle");
      cloned.find("i").removeClass("fa fa-plus-circle");
      cloned.find("a").removeClass("add-same-booster-again");
      cloned.find("i").removeClass("add-same-booster-again");
      cloned.find("a").addClass("fa fa-minus-circle");
      cloned.find("a").addClass("delete-same-booster-again");
      cloned.find('input').val('');
      cloned.find(".booster_doses_value_class").val(value);
      var dateFormatStr =  getJsDateFormat();
      cloned.find(".booster-date-cls").removeClass("hasDatepicker");
      cloned.find(".booster-due-date-cls").removeClass("hasDatepicker");
      cloned.insertAfter( lastRepeatingGroup );
      var rows_length = $(".boster-doses-new-inline-row").length
      $(".boster-doses-new-inline-row:visible").each(function(index,element){
      var data1=rows_length
      cloned.find('.booster-due-date-cls').attr('id',   "booster_due_date_" +  data1);
      cloned.find('.booster-due-date-cls').attr('name',   "booster_due_date["+data1+"]");
      cloned.find('.booster-date-cls').attr('id',   "date_" +  data1);
      cloned.find('.booster-date-cls').attr('name',   "date["+data1+"]");
      rows_length=rows_length+1
    });
  }
  abcd();
});


$(document).on("click", ".delete-same-booster-again", function(e){
  $(this).parent().parent(".boster-doses-new-inline-row").last().remove();
});
function submission_criteria(){
  $( ".booster_date_class" ).each(function() {
    $(this).siblings(".booster_date_cpy_class").val($(this).val());
    $(this).parent(".booster-date-td-class").siblings(".booster-due-date-td-class").children(".booster_due_date_cpy_class").val($(this).parent(".booster-date-td-class").siblings(".booster-due-date-td-class").children(".booster_due_date_class").val());
  });
  $(".vaccination-list-class").click();
}

//==================jquery for allergy=======================



function allergyFunction(student_id){
  $('#allergyRecordDivID').empty();
  var batch_id=$("#allergy_mg_batch_id").val();
  var urlLink='/healthcare/allergy_record';
  if(student_id!=''){
    $.ajax({
      url: urlLink ,
      cache: false,
      data:{mg_batch_id:batch_id,mg_student_id:student_id},
      success: function(data){
        $('#allergyRecordDivID').empty();
        $('#allergyRecordDivID').html(data)
      }
    });
  }
}

function allergyEmployeeFunction(employee_id){
  $('#allergyRecordDivID').empty();
  var department_id=$("#allergy_mg_employee_department_id").val();
  var urlLink='/healthcare/allergy_record';
  if(employee_id!=''){
    $.ajax({
      url: urlLink ,
      cache: false,
      data:{mg_employee_department_id:department_id,mg_employee_id:employee_id},
      success: function(data){
        $('#allergyRecordDivID').empty();
        $('#allergyRecordDivID').html(data)
      }
    });
  }
}

function classChange(batch_id){
  $.ajax({
    url: '/healthcare/student_list_table',
    data:{"mg_batch_id":batch_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].admission_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#allergy_mg_student_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#allergy_mg_student_id").empty().append(apdStr);;
      }
    }
  });
}

function departmentChangeAllergyForm(department_id){
  $.ajax({
    url: '/healthcare/employee_list_table',
    data:{"mg_employee_department_id":department_id},
    cache: false,
    success: function(data){
      if(data.length > 0){
        var apdStr = '<option value="">Select</option>';
        for(key in data){
          apdStr += '<option value="'+data[key].id+'">'+data[key].employee_number+" - "+data[key].first_name.substr(0,1).toUpperCase()+data[key].first_name.substr(1)+" "+data[key].last_name.substr(0,1).toUpperCase()+data[key].last_name.substr(1)+'</option>'
        }
        $("#allergy_mg_employee_id").empty().append(apdStr);
      }
      else{
        var apdStr = '<option value="">Select</option>';
        $("#allergy_mg_employee_id").empty().append(apdStr);;
      }
    }
  });
}

$(document).on("click",".allergy-student-cls",function(){
  var apdStr = '<option value="">Select</option>';

  if($(this).is(':checked')){
    $("#allergy_mg_employee_id").empty().append(apdStr);
    $("#allergyRecordDivID").empty();
    $("#employeeDivId").hide();
    $("#studentDivId").show();
  }
});

$(document).on("click",".allergy-employee-cls",function(){
  var apdStr = '<option value="">Select</option>';
  if($(this).is(':checked')){
    $("#allergy_mg_student_id").empty().append(apdStr);
    $("#allergyRecordDivID").empty();
    $("#studentDivId").hide();
    $("#employeeDivId").show();
  }
});
