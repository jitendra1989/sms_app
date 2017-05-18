/* comm */
// index js start
// i have look the code
       



// $(document).on("click", ".atts-class-student", function(e){
//         e.preventDefault();
// });

function addClassBatches(){

  var batchID=$("#batch").val();

  var absentDate=$("#date").val();
  if(batchID && absentDate && $("#employeeReportAttendancesFormID").valid()){
    jQuery.ajax({
            url: "/attendances/time_table_for_attendance",
            type: "GET",
            data: {"mg_batch_id" :batchID, absentDate: absentDate},
            dataType: "html",
            success: function(data2) {
              // $("#classTimingListForStudentAttendaceDIVID").empty();
              $('#absentPeriodWiseStudentAattendanceeditDIVID').empty();
              $('#absentPeriodWiseStudentAattendanceDIVID').empty();
              $('#studentPeriodWiseTimeTableDIVID').empty();
              $("#classTimingListForStudentAttendaceDIVID").html(data2);
            },
            error:function(){
              alert("Please Select Section");
            }
        });
  }else{
    $("#classTimingListForStudentAttendaceDIVID").html('');
  }
  
  }

// var flagDialog = true;

$(document).on("click", ".student-attendance-by-period-wise", function(e){
   e.preventDefault();
   // if(flagDialog){
   //    flagDialog = false;
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var mg_student_id=Id[0];
        // var mg_student_id=Id[0];
        var absentDate=$("#date").val();
    // alert("Step -- 1");
    var batchID=$("#batch").val();
    console.log("batchID :"+batchID);
    var absentDate=$("#date").val();
   
        var urlLink = "/attendances/attendance_new_period/";
        $.ajax({
            url: urlLink ,
            data:{
               absentDate: absentDate, batchID: batchID, mg_student_id: mg_student_id
            },
            cache: false,
            success: function(html){
                    $('#studentPeriodWiseTimeTableDIVID').empty();
                    $('#absentPeriodWiseStudentAattendanceeditDIVID').empty();
                    $('#absentPeriodWiseStudentAattendanceDIVID').empty();
                    // we use like that s=also for fresh data content
                    // $('#studentPeriodWiseTimeTableDIVID').empty().dialog();
                  $('#studentPeriodWiseTimeTableDIVID').dialog({
                    // modal: true,
                    width: 'auto',
                    title: "Mark Absent",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
      // }
});


// var flagDialogPeriodAtt = true;
 
$(document).on("click",".student-attendance-period-wise-save-BTN",function(e){
    e.preventDefault();

    $(".student-attendance-period-wise-save-BTN").prop('disabled', true);
      //   if(flagDialogPeriodAtt){
      // flagDialogPeriodAtt = false;
       var myID =$(this).attr('id');
        var Id=myID.split("-");
        var reason=$("#attendances_reason").val();
        // alert("reason : is -- >"+reason);
 
        var urlLink = "/attendances/attendance_create/"+Id[0];

        $.ajax({
         
            url: urlLink ,
            cache: false,
            data: {attendancedate: "periodwiseedit", reason: reason},
            success:function(data){
                  $(".ui-dialog-titlebar-close").click();
                },
            error: function(){
              alert("Error: Please try again.");
            }
        
        }); 
    // }
});
// var flagDialog = true;

$(document).on("click",".delete-period-wise-attendance-BTN",function(e){
    e.preventDefault();
     // if(flagDialog){
     //  flagDialog = false;
    var myID =$(this).attr('id');
        var Id=myID.split("-");


  var mg_student_id=$("#attendances_mg_student_id").val();
      // var id=$("#attendances_id").val();
      var mg_class_timing_id=$("#attendances_mg_class_timing_id").val();

        $.ajax({
        url: "/attendances/delete/"+Id[0],
        type: "patch",
        cache: false,
       

        success:function(data){
            var data=$(document.getElementById(mg_class_timing_id+'-'+mg_student_id+'-timeingsAID')).html()
                // var data=$(document.getElementById("65-4-timeingsAIDB")).html()
                // alert(data);
                 console.log("data : "+data);
                 if(data=='<i class="fa fa-circle"></i>'){

                 
                  $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').empty();
                  $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').append('<i class="fa fa-check"> </i>');
               
                }
           $(".ui-dialog-titlebar-close").click();
            },
        error: function(){
          alert("Error: Please try again.");
        }
}); 
    // }

});


// var flagDialogNewPeriodWiseAttendance = true;
$(document).on("click", "#studentAttendancePeriodWiseSaveBTNID", function(e){
    $('#studentAttendancePeriodWiseSaveBTNID').prop('disabled', true);
     e.preventDefault();
  // if(flagDialogNewPeriodWiseAttendance){
  //     flagDialogNewPeriodWiseAttendance = false;
        var reason=$("#attendances_reason").val();
        // alert("reason :"+reason);
        var mg_batch_id=$("#attendances_mg_batch_id").val();
        // alert("mg_batch_id :"+mg_batch_id);

        var mg_student_id=$("#attendances_mg_student_id").val();
        // alert("mg_student_id :"+mg_student_id);

        var absent_date=$("#attendances_absent_date").val();
        // alert("absent_date :"+absent_date);
        
        var mg_school_id=$("#attendances_mg_school_id").val();
        // alert("mg_school_id :"+mg_school_id);
        
        var created_by=$("#attendances_created_by").val();
        // alert("created_by :"+created_by);
        
        var updated_by=$("#attendances_updated_by").val();
        // alert("updated_by :"+updated_by);
        
        var mg_class_timing_id=$("#attendances_mg_class_timing_id").val();
        // alert("mg_class_timing_id :"+mg_class_timing_id);

        var urlLink = "/attendances/attendance_create/"+mg_batch_id;
        $.ajax({
            url: urlLink ,
            data:{
                  attendancedate:"periodwise",mg_class_timing_id: mg_class_timing_id, reason: reason, mg_batch_id: mg_batch_id, mg_student_id: mg_student_id, absent_date: absent_date, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by, is_deleted: 0
            },
            cache: false,
            success: function(dataq){
                 // alert("successfully saved");
                 // flagDialogNewPeriodWiseAttendance=true
              var mg_class_timing_id=$("#attendances_mg_class_timing_id").val();
              console.log("mg_class_timing_id :"+mg_class_timing_id);
              var mg_school_id=$("#attendances_mg_school_id").val();
              console.log("mg_school_id :"+mg_school_id);

                
                var data=$(document.getElementById(mg_class_timing_id+'-'+mg_student_id+'-timeingsAID')).html()
                // var data=$(document.getElementById("65-4-timeingsAIDB")).html()
                // alert(data);
                 console.log("data : "+data);
                 if(data=='<i class="fa fa-check"> </i>'){

                 
                  $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').empty();
                  $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').append('<i class="fa fa-circle"></i>');  
               
                }
               
               $(".ui-dialog-titlebar-close").click();
            }

        });

      // }
});


// var flagDialogForEitNewDelete = true;

$(document).on("click", ".click-absent-student-attendance-additional-cls", function(e){
  e.preventDefault();
  // if(flagDialogForEitNewDelete){
  //     flagDialogForEitNewDelete = false;
                    var myID =$(this).attr('id');
                    var ckeckvalue=$("#"+myID).html();
                   
                    var reason_check=$("#is_resion").is(':checked');
                    if(reason_check){
                        var Id=myID.split("-");
                                            var mg_class_timing_id=Id[0];
                                            var mg_student_id=Id[1];
                                            var batchID=$("#batch").val();
                                            console.log("batchID :"+batchID);
                                            var absentDate=$("#date").val();
                                            console.log("absentDate :"+absentDate);
                                            console.log("mg_student_id :"+mg_student_id);
                                            console.log("mg_class_timing_id :"+mg_class_timing_id);
                                            var reason_check=$("#is_resion").is(':checked');

                                          var mg_school_id=$("#attendances_mg_school_id").val();
                                          var created_by=$("#attendances_created_by").val();
                                          var updated_by=$("#attendances_updated_by").val();

                            if('<i class="fa fa-circle"></i>'==ckeckvalue){
                                         var urlLink = "/attendances/period_attendence_save/"+batchID;
                                              $.ajax({
                                                  url: urlLink ,
                                                  data:{
                                                    mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, absentDate: absentDate, mg_student_id: mg_student_id, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by, is_reason: reason_check, edit: "true"
                                                  },
                                                  cache: false,
                                                  success: function(html){
                                                    $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').empty();
                                                    $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').append('<i class="fa fa-check"> </i>');
                                                     // flagDialogForEitNewDelete = true;
                                                  }

                                                      
                                          
                                        });
                            }else{
                                            
                                              var urlLink = "/attendances/period_attendence_save/"+batchID;
                                              $.ajax({
                                                  url: urlLink ,
                                                  data:{
                                                    mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, absentDate: absentDate, mg_student_id: mg_student_id, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by, is_reason: reason_check
                                                  },
                                                  cache: false,
                                                  success: function(html){
                                                    $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').empty();
                                                    $("#"+mg_class_timing_id+'-'+mg_student_id+'-timeingsAID').append('<i class="fa fa-circle"></i>');
                                                    // flagDialogForEitNewDelete = true;
                                                  }

                                                      
                                          
                                        });
                                }




                    }else{
                    var Id=myID.split("-");
                    if('<i class="fa fa-circle"></i>'==ckeckvalue){
                        var mg_class_timing_id=Id[0];
                          var mg_student_id=Id[1];
                          var batchID=$("#batch").val();
                          console.log("batchID :"+batchID);
                          var absentDate=$("#date").val();
                          console.log("absentDate :"+absentDate);
                          console.log("mg_student_id :"+mg_student_id);
                          console.log("mg_class_timing_id :"+mg_class_timing_id);
                          var mg_school_id=$("#attendances_mg_school_id").val();
                          console.log("mg_school_id :"+mg_school_id);
                          var reason_check=$("#is_resion").is(':checked');
                          var created_by=$("#attendances_created_by").val();
                          var updated_by=$("#attendances_updated_by").val();
                              var urlLink = "/attendances/period_attendence_edit/"+batchID;
                              $.ajax({
                                  url: urlLink ,
                                  data:{
                                    mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, absentDate: absentDate, mg_student_id: mg_student_id, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by, is_reason: reason_check
                                  },
                                  cache: false,
                                  success: function(attendancesEdit){
                                        $('#studentPeriodWiseTimeTableDIVID').empty();
                                        $('#absentPeriodWiseStudentAattendanceeditDIVID').empty();
                                        $('#absentPeriodWiseStudentAattendanceDIVID').dialog({
                                          // modal: true,
                                          width: 'auto',
                                          title: "Edit Period wise Attendance ",
                                          open: function () {
                                              
                                              $(this).html(attendancesEdit);
                                          }
                                      }); 
                                     // flagDialogForEitNewDelete = true;
                                  }
                            });

                             
                    }else{
                            var mg_class_timing_id=Id[0];
                            var mg_student_id=Id[1];
                            var batchID=$("#batch").val();
                            console.log("batchID :"+batchID);
                            var absentDate=$("#date").val();
                            console.log("absentDate :"+absentDate);
                            console.log("mg_student_id :"+mg_student_id);
                            console.log("mg_class_timing_id :"+mg_class_timing_id);
                            var reason_check=$("#is_resion").is(':checked');

                          var mg_school_id=$("#attendances_mg_school_id").val();
                          var created_by=$("#attendances_created_by").val();
                          var updated_by=$("#attendances_updated_by").val();
                              var urlLink = "/attendances/period_attendence_save/"+batchID;
                              $.ajax({
                                  url: urlLink ,
                                  data:{
                                    mg_class_timing_id: mg_class_timing_id, mg_batch_id: batchID, absentDate: absentDate, mg_student_id: mg_student_id, mg_school_id: mg_school_id, created_by: created_by, updated_by: updated_by, is_reason: reason_check
                                  },
                                  cache: false,
                                  success: function(html){
                                        $('#absentPeriodWiseStudentAattendanceDIVID').empty();
                                        $('#studentPeriodWiseTimeTableDIVID').empty();
                                        $('#absentPeriodWiseStudentAattendanceeditDIVID').dialog({
                                          modal: true,
                                          width: 'auto',
                                          title: "Create Attendance",
                                          open: function () {
                                              
                                              $(this).html(html);
                                          }
                                      }); 

                                       flagDialogForEitNewDelete = true;
                                     
                                  }
                          
                        });

                      }

                  }
    // }
});


//update and delete

$(document).on("click", ".atts-class-student-update", function(e){
   e.preventDefault();
  // alert("hi");
 var studentCategoryID =$(this).attr('id');
        
}); 

// });

// index js finish

// new js start




// function hideAll()
// {
//   //alert("i m in fullday");
//      //alert("i'm in toggleAll function");
//  $("#whatever").hide();
// }

$(document).on("click", "#attendances_halfday", function(){
 
       var depVal = $("#attendances_halfday").is(':checked')

       //alert(depVal);

       $("#halfdayfield").val(depVal);
        });


$(document).on("click", "#attendances_is_afternoon_false", function(){

       var depVal = $("#attendances_is_afternoon_false").val();
       $("#afternoonfield").val(depVal);
        });


$(document).on("click", "#attendances_is_afternoon_true", function(){
    
       var depVal = $("#attendances_is_afternoon_true").val();
       $("#afternoonfield").val(depVal);
        });
// new js finish


$(document).on("click",".atts-class-student", function(e){
   e.preventDefault();
  var student_date =$(this).attr('id');
   var x=document.getElementById(student_date);
  if(x.innerHTML=='<i class="fa fa-circle"> </i>'){
    isCheckStudent(student_date);
  }else{
     isCircleStudent(student_date);
  }
});



function isCircleStudent(student_date){
        var date_student_id=student_date;
        var batchId  = $("#attendances_mg_batch_id").val();
        var my=$(".attendance-month hasDatepicker").val();
        var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
        var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());
        var urlLink = "/attendances/new";
        $.ajax({
             url: urlLink ,
            data: {'batchId': batchId, 'date_student_id':date_student_id, 'month':month, 'year':year},

            cache: false,
            success: function(html){
                  $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    modal: true,
                    title: "Attendance",
                    open: function () {
                        $(this).html(html);
                    },
                    close: function (e) {
                        $(this).empty();
                    }
                }); 
               
            }
        });


}

function isCheckStudent(student_date){

    var date_student_id=student_date;
         var student_id = date_student_id.split(",");
         var batchId = $( "#attendances_mg_batch_id" ).val();
          var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
          var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());
         var urlLink = "/attendances/"+student_id[1]+"/edit";
        $.ajax({
             url: urlLink ,
            data: {'batchId': batchId, 'date_student_id':date_student_id, 'month':month, 'year':year},
            cache: false,
            success: function(html){
                  $('<div id="attendanceDialogID" class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
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

}