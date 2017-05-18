$(document).on("click","#mg_employee_attendance_save_btns",function(e){
   e.preventDefault();
    var reason=$("#student_hostel_attendances_reason").val();
    var absent_without_notice=$("input#student_hostel_attendances_absent_without_notice").is(':checked');
    var isDeleted=$("#student_hostel_attendances_is_deleted").val();
    var employee_id=$("#student_hostel_attendances_mg_employee_id").val();
    var absent_date=$("#student_hostel_attendances_absent_date").val();
    var is_approved=$("#student_hostel_attendances_is_approved").val();
    var is_late=$("input#student_hostel_attendances_is_late_come").is(':checked');
    var time=$("#student_hostel_attendances_time").val();
    attendanceForEmployees();
});



//new start
function attendanceForEmployees(){
  $("#mg_employee_attendance_save_btns").prop('disabled', true);
  var employee_id=$("#student_hostel_attendances_mg_employee_id").val();
  var absent_date=$("#student_hostel_attendances_absent_date").val();
  var is_late=$("input#student_hostel_attendances_is_late_come").is(':checked');
  var employees_attendances_reason=$('#student_hostel_attendances_reason').val();
  var employees_attendances_reason=$('#student_hostel_attendances_reason').val();
    var urlLink = "/hostel_management/attendance_validation";
        $.ajax({
             url: urlLink ,
            data: { "mg_employee_id": employee_id,
                    "absent_date": absent_date,
                    "is_late": is_late
                  },
            cache: false,
            success: function(data){
                  if(data.notice=='date_equal_to_absent_date'){
                   alert("Can't absent on joining date.");
                     $(".ui-dialog-titlebar-close").click(); 
                   
                  }else if(data.notice=='absent_date_present'){
                    alert("already absent for selected date range.");
                     $(".ui-dialog-titlebar-close").click(); 
                  }else{
                    attendanceForEmployee_validation();
                  }
            }
           
        });
}


function attendanceForEmployee_validation(){
    var mg_hostel_detail_id=$("#student_hostel_attendances_mg_hostel_detail_id").val();
    var mg_wing_id=$("#student_hostel_attendances_mg_wing_id").val();
    var mg_wing=mg_wing_id.split("-");
    var reason=$("#student_hostel_attendances_reason").val();
    var morning_reason=$("#student_hostel_attendances_morning_reason").val();
    var absent_without_notice=$("input#student_hostel_attendances_absent_without_notice").is(':checked');
    var isDeleted=$("#student_hostel_attendances_is_deleted").val();
    var employee_id=$("#student_hostel_attendances_mg_employee_id").val();
    var absent_date=$("#student_hostel_attendances_absent_date").val();
    var is_approved=$("#student_hostel_attendances_is_approved").val();
    var is_late=$("input#student_hostel_attendances_is_late_come").is(':checked');
    var time=$("#student_hostel_attendances_time").val();
    var mororeve=$("#student_hostel_attendances_mororeve").val();
    var URL='/hostel_management/create'
    $.ajax({
        url: URL ,
        type: "POST",
        cache: true,
        data: {"mg_employee_id": employee_id,//"mg_leave_type_id":leaveType,
                "absent_date": absent_date,//"mg_employee_department_id":department_id,
                "reason": reason//,"is_halfday":halfday,"is_afternoon":time1
                ,"mg_hostel_detail_id": mg_hostel_detail_id,
                "mg_wing_id": mg_wing[0],
                "absent_without_notice": absent_without_notice,//"leave_type":leaveType,
                "is_late_come": is_late,
                "time": time,
                "mororeve": mororeve,
                "morning_reason": morning_reason
                //,"is_lock":is_lock
              },

        success:function(data){
          attendanceAfterSuccess();
        }
    }); 
  }



// ===================================update dialog box work========================

$(document).on("click",".spanMorningCircleClass",function(){
  var employee_date =$(this).attr('id');
  var date_student_id=employee_date;
  var student_id = date_student_id.split(",");
  var mg_hostel_id = $( "#mg_hostel_list" ).val();
  var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
  var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());
  if(isNaN(month)){
    var presentDate = new Date();
    month=presentDate.getMonth()+1;
    year=presentDate.getFullYear();
  }
  var urlLink = "/hostel_management/"+student_id[1][0]+"/edit_attendance";
  $.ajax({
    url: urlLink ,
    data: {"update_attendance":"morning_attendance",'mg_hostel_id': mg_hostel_id, 'date_student_id':date_student_id, 'month':month, 'year':year},
    // data: {'mg_employee_departments_id': deptId, 'date_student_id':date_student_id, 'month':month, 'year':year},
    cache: false,
    success: function(html){
      $('#employeeAttendanceDIVID1').dialog({
        title: "Attendance Details",
        model: false,
        open: function () {
          $(this).html(html);
        },
        close: function (e) {
          $(this).empty();
        }
      }); 
    }
  });
})



$(document).on("click",".spanEveningCircleClass",function(){
  var employee_date =$(this).attr('id');
  var date_student_id=employee_date;
  var student_id = date_student_id.split(",");
  var mg_hostel_id = $( "#mg_hostel_list" ).val();
  var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
  var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());
  if(isNaN(month)){
    var presentDate = new Date();
    month=presentDate.getMonth()+1;
    year=presentDate.getFullYear();
  }
  var urlLink = "/hostel_management/"+student_id[1][0]+"/edit_attendance";
  $.ajax({
    url: urlLink ,
    data: {"update_attendance":"evening_attendance",'mg_hostel_id': mg_hostel_id, 'date_student_id':date_student_id, 'month':month, 'year':year},
    // data: {'mg_employee_departments_id': deptId, 'date_student_id':date_student_id, 'month':month, 'year':year},
    cache: false,
    success: function(html){
      $('#employeeAttendanceDIVID1').dialog({
        title: "Attendance Details",
        model: false,
        open: function () {
          $(this).html(html);
        },
        close: function (e) {
          $(this).empty();
        }
      }); 
    }
  });
})






//=========================update work by Jitendra start============================

$(document).on("click","#mg_student_attendance_update_btn",function(e){
  e.preventDefault();
  var attendance_period=$("#update_attendance").val();
  var morning_reason=$("#student_attendances_morning_reason").val();
  var evening_reason=$("#student_attendances_evening_reason").val();
  var morning_late_reason=$("#student_attendances_morning_late_reason").val();
  var evening_late_reason=$("#student_attendances_evening_late_reason").val();
  var absent_without_notice=$("input#student_attendances_absent_without_notice").is(':checked');
  var isDeleted=$("#student_attendances_is_deleted").val();
  var mg_hostel_detail_id=$("#student_attendances_mg_hostel_detail_id").val();
  var mg_wing_id=$("#student_attendances_mg_wing_id").val();
  var mg_student_id=$("#student_attendances_mg_student_id").val();
  var absent_date=$("#student_attendances_absent_date").val();
  var is_late=$("input#student_attendances_is_late_come").is(':checked');
  var is_evening_late=$("input#student_attendances_is_evening_late_come").is(':checked');
  var time=$("#student_attendances_time").val();
  var evening_late_time=$("#student_attendances_evening_late_time").val();
  var id=$("#student_attendances_id").val();
  if (is_late==true || is_evening_late==true){
    if (attendance_period=="morning_attendance"){
      if(document.getElementById('student_attendances_morning_late_reason').value == ''){      
        alert("Please provide reason.");
        document.getElementById('student_attendances_morning_late_reason').focus();
        return false;       
      }
      if(document.getElementById('student_attendances_time').value == ''){      
        alert("Please provide time.");
        document.getElementById('student_attendances_time').focus();
        return false;       
      }
    }else{
      if(document.getElementById('student_attendances_evening_late_reason').value == ''){      
        alert("Please provide reason.");
        document.getElementById('student_attendances_evening_late_reason').focus();
        return false;       
      }
      if(document.getElementById('student_attendances_evening_late_time').value == ''){      
        alert("Please provide time.");
        document.getElementById('student_attendances_evening_late_time').focus();
        return false;       
      }
    }
    edit_student_attendance();
  }else{
    if (attendance_period=="morning_attendance"){
      if(document.getElementById('student_attendances_morning_reason').value == ''){      
        alert("Please provide reason.");
        document.getElementById('student_attendances_morning_reason').focus();
        return false;       
      }
    }else{
      if(document.getElementById('student_attendances_evening_reason').value == ''){      
        alert("Please provide reason.");
        document.getElementById('student_attendances_evening_reason').focus();
        return false;       
      }
    }
    edit_student_attendance();
  }
});


function edit_student_attendance(){
  $("#mg_student_attendance_update_btn").prop('disabled', true);
  var absent_without_notice=$("input#student_attendances_absent_without_notice").is(':checked');
  var isDeleted=$("#student_attendances_is_deleted").val();
  var mg_hostel_detail_id=$("#student_attendances_mg_hostel_detail_id").val();
  var mg_wing_id=$("#student_attendances_mg_wing_id").val();
  var mg_student_id=$("#student_attendances_mg_student_id").val();
  var absent_date=$("#student_attendances_absent_date").val();
  var is_late=$("input#student_attendances_is_late_come").is(':checked');
  var is_evening_late=$("input#student_attendances_is_evening_late_come").is(':checked');
  var time=$("#student_attendances_time").val();
  var evening_late_time=$("#student_attendances_evening_late_time").val();
  var id=$("#student_attendances_id").val();
  var morning_reason=$("#student_attendances_morning_reason").val();
  var evening_reason=$("#student_attendances_evening_reason").val();
  var morning_late_reason=$("#student_attendances_morning_late_reason").val();
  var evening_late_reason=$("#student_attendances_evening_late_reason").val();
  var update_attendance=$("#update_attendance").val();
  $.ajax({
    url: "/hostel_management/"+id,
    type: "patch",
    cache: false,
    data: {"update_attendance":update_attendance,"mg_student_id":mg_student_id,"absent_date":absent_date,"mg_hostel_detail_id":mg_hostel_detail_id,"morning_reason":morning_reason,"evening_reason":evening_reason,"morning_late_reason":morning_late_reason,"evening_late_reason":evening_late_reason,"is_deleted":isDeleted,"absent_without_notice":absent_without_notice, "is_late_come":is_late,"is_evening_late":is_evening_late, "time":time,
    "evening_late_time":evening_late_time},
    success:function(data){
      $(".ui-dialog-titlebar-close").click();
      attendanceAfterSuccess();
    },
    error: function(){
      alert("Error: Please try again.");
    }
  }); 
}


$(document).on("click","#mg_student_attendance_clear_btn",function(e){
  var id=$("#student_attendances_id").val();
  var delete_attendance_period=$("#update_attendance").val();
  $.ajax({
    url: "/hostel_management/delete_attendance",
    type: "patch",
    cache: false,
    data: {"delete_attendance_period":delete_attendance_period,"id":id},
    success:function(data){
     
      $(".ui-dialog-titlebar-close").click();
      attendanceAfterSuccess();
    },
    error: function(){
      alert("Error: Please try again.");
    }
  }); 
});





//======================all day report showings ===========================

$(document).on("click",".is-student-all-day-count",function(e){
  e.preventDefault();

  var id =$(this).attr('id');
  var arr = id.split(",");
    $.ajax({
    url: "/hostel_management/leave_report/",
    type: "get",
    cache: false,
    data:{ "student":"allday", start_date:arr[0], end_date:arr[1], studentID:arr[2]},
    success:function(data){
      if(data.morningObject.length >0 || data.eveningObject.length>0 || data.fullday.length){
                                     
        var str=" <h5 class='mg-custom-labels mg-font-bold'>Morning</h5>"
         str +='<div style="padding: 0 10px 0 8px;"><table class="batch-tbl mg-tbl-margin" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th class="mg-table-nowrap">Absent Date</th><th class="mg-table-nowrap">Reason</th></tr>';
        for(key in data.morningObject ){
          var absentDate=data.morningObject[key].absent_date;
          var reson=data.morningObject[key].morning_reason;
          var morning_late_reason=data.morningObject[key].morning_late_reason;
          // var reson=data.morningObject[key].reason;
          if (reson==''){
            str +='<tr class="employee-class" rowspan="2"><td>'+$.datepicker.formatDate('dd/mm/yy',new Date(absentDate))+'</td><td>'+morning_late_reason+'</td></tr>';
          }else{
            str +='<tr class="employee-class" rowspan="2"><td>'+$.datepicker.formatDate('dd/mm/yy',new Date(absentDate))+'</td><td>'+reson+'</td></tr>';
          }
        }
        str +='</table></div>';
        str +=" <hr><h5 class='mg-custom-labels mg-font-bold'>Evening</h5>"

        str +='<div style="padding: 0 10px 0 8px;"><table class="batch-tbl mg-tbl-margin" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th class="mg-table-nowrap">Absent Date</th><th class="mg-table-nowrap">Reason</th></tr>';
        
        for(key in data.eveningObject ){
          var absentDate=data.eveningObject[key].absent_date;
          var reson=data.eveningObject[key].evening_reason;
          var evening_late_reason=data.eveningObject[key].evening_late_reason;
          // var reson=data.eveningObject[key].reason;
          if(reson==''){
            str +='<tr class="employee-class" rowspan="2"><td>'+$.datepicker.formatDate('dd/mm/yy',new Date(absentDate))+'</td><td>'+evening_late_reason+'</td></tr>';
          }else{
            str +='<tr class="employee-class" rowspan="2"><td>'+$.datepicker.formatDate('dd/mm/yy',new Date(absentDate))+'</td><td>'+reson+'</td></tr>';
          }
        }
        str +='</table></div>';
        str +=" <hr><h5 class='mg-custom-labels mg-font-bold'>Full Days </h5>"

        str +='<div style="padding: 0 10px 0 8px;"><table class="batch-tbl mg-tbl-margin" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th class="mg-table-nowrap">Absent Date</th><th class="mg-table-nowrap">Reason</th></tr>';
              
        for(key in data.fullday ){
          var absentDate=data.fullday[key].absent_date;
          var morning_reason=data.fullday[key].morning_reason;
          var evening_reason=data.fullday[key].evening_reason;
          // var reson=data.fullday[key].reason;
          if(morning_reason==''){
            str +='<tr class="employee-class" rowspan="2"><td>'+$.datepicker.formatDate('dd/mm/yy',new Date(absentDate))+'</td><td>'+evening_reason+'</td></tr>';
          }else{
            str +='<tr class="employee-class" rowspan="2"><td>'+$.datepicker.formatDate('dd/mm/yy',new Date(absentDate))+'</td><td>'+morning_reason+'</td></tr>';
          }
        }

        str +='</table></div>';
        
        str += "<br/><a class='mg-small-form-btn cancel-form-dialog' href='#'>Cancel</a><br/>"

        $('#studentFullAttendanceID').dialog({
          modal: true,
          title: "All Days Details",
          width: 'auto',
          open: function () {
            $(this).html(str);
          }
        }); 
      }else{
        alert("Didn't take any holiday");
      }
    },
     error: function(){
      alert("Error: Please try again.");
    }
  }); 
});




 function hostler(){
  var myID =$("#mg_hostel_details_id").val();
  var urlLink = "/hostel_management/select_programme_data";
  $.ajax({
    url: urlLink ,
    cache: false,
    data:{id:myID},
    success: function(html){
      $('#mg_programme_details').empty().html(html.main);
    }
  });
};

//======================all day report showings end ===========================















$(document).on("change",".check_box_tag_data",function(){
  var data_id_value=$(this).attr('id');
  var data_array=data_id_value.split("_");
  var hostel_data = $("#allocate_rooms_hostel_id").val();
  var room_data_id = $("#mg_room_no_id_"+data_array[2]).val();
  var urlLink = "/hostel_management/manage_central_data";
  var availability = $("#capacity_of_available_"+data_array[2]).val();

  if(parseInt(availability) < parseInt("0") || availability == ""){
    alert("Can't be selected");
    $(this).attr('checked', false);
  }else{
    if($(this).prop("checked") == true && parseInt(availability)!=0){
      if(room_data_id!=''){
        $.ajax({
          url: urlLink,
          cache: false,
          data:{hostel_id:hostel_data,room_id:room_data_id,data:"check_box"},
          success: function(html){
            $(".check_box_tag_data").each(function(){
              if (room_data_id==$(this).parent().siblings().find(".room_no_value").val()){
                $(this).parent().siblings().find(".capacity_of_available_data").empty().val(html.main);
              }
            });
          }
        });
      }else{
        alert("Can't be selected");
        $(this).attr('checked', false);
      }
    }else if($(this).prop("checked") == false && parseInt(availability)>=0){
      $.ajax({
        url: urlLink,
        cache: false,
        data:{hostel_id:hostel_data,room_id:room_data_id,data:"un_check_box"},
        success: function(html){
          $(".check_box_tag_data").each(function(){
            if (room_data_id==$(this).parent().siblings().find(".room_no_value").val()){
              $(this).parent().siblings().find(".capacity_of_available_data").empty().val(html.main);
            }
          });
        }
      });
    }else{
      alert("Can't be selected");
      $(this).attr('checked', false);
    }
  }
});



$(document).on("change",".floor_data_value",function(){
  if($(this).parent().siblings().find(".check_box_tag_data").prop("checked") == true){
    alert("uncheck the checkbox")
  }else{
    $(this).parent("td").siblings(".mg-select-room-cls").find("select").val('');
    var data=$(this).val();
    var data_id_value=$(this).attr('id');
    var data_array=data_id_value.split("_");
    var hostel_data = $("#allocate_rooms_hostel_id").val();
    var urlLink = "/hostel_management/manage_central_data";
    $.ajax({
      url: urlLink,
      cache: false,
      data:{hostel_id:hostel_data,floor_data:data,data:"floor"},
      success: function(html){
        $("#mg_room_type_id_"+data_array[3]).empty().append(html.main);
      }
    });
  }
});


$(document).on("click",".checkbox-toggle-cls",function(){

    if($(this).parent("td").siblings(".mg-select-room-cls").find("select").is(':disabled')){
      $(this).parent("td").siblings(".mg-select-room-cls").find("select").prop( "disabled",false);
      $(this).parent("td").siblings(".mg-select-room-type-cls").find("select").prop( "disabled",false);
      $(this).parent("td").siblings(".mg-select-floor-cls").find("select").prop( "disabled",false);
    }
  });

  function allocateRoomSubmitForm(){
    $(".checkbox-toggle-cls").each(function(){
      if($(this).parent("td").siblings(".mg-select-room-cls").find("select").is(':disabled')){
        $(this).parent("td").siblings(".mg-select-room-cls").find("select").prop( "disabled",false);
        $(this).parent("td").siblings(".mg-select-room-type-cls").find("select").prop( "disabled",false);
        $(this).parent("td").siblings(".mg-select-floor-cls").find("select").prop( "disabled",false);
      }
    });
    $(".allocate-room-submit-cls").click();
  }

$(document).on("change",".room_no_value",function(){
  if($(this).parent().siblings().find(".check_box_tag_data").prop("checked") == true)
  {
    alert("uncheck the checkbox")
  }else{
    var data=$(this).val();
    var data_id_value=$(this).attr('id');
    var data_array=data_id_value.split("_");
    var hostel_data = $("#allocate_rooms_hostel_id").val();
    var urlLink = "/hostel_management/manage_central_data";
    
    if(data!=''){
      $.ajax({
        url: urlLink,
        cache: false,
        data:{hostel_id:hostel_data,id_data:data,data:"capacity"},
        success: function(html){
          $("#capacity_of_available_"+data_array[4]).empty().val(html.main);
        }
      });
    }
  }
});
