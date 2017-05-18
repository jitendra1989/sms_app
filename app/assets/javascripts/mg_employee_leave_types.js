/* comm */
$(document).on("click", ".showLeaveClass", function(e){
  e.preventDefault();
// alert("abc");
        var myID =$(this).attr('id');
         // alert(myID);

       var splString = myID.split("-");
     //  alert(splString);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/mg_employee_leave_types/"+splString[1];
    // alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $("#leaveTypeShowDilogID").dialog({
                    width: 'auto',
                    height: 420,
                    modal: true,
                    title: "Show Employee Leave Types",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", "#employeeLeaveApplyFormBTNID", function(e){
   e.preventDefault();

        var leave_type=$("#mg_employee_leave_types_leave_type").val();
        console.log("leave_type :"+leave_type);

        var from_date=$("#mg_employee_leave_types_from_date").val();
        console.log("from_date :"+from_date);

        var to_date=$("#mg_employee_leave_types_to_date").val();
        console.log("to_date :"+to_date);

        var half_day_date=$("#mg_employee_leave_types_half_day_date").val();
        console.log("half_day_date :"+half_day_date);

        var is_halfday = $("#emp_attendances_halfday").is(':checked')
        console.log("is_halfday :"+is_halfday);
        var mg_employee_id=$("#mg_employee_leave_types_mg_employee_id").val();
        console.log("mg_employee_id :"+mg_employee_id);
        var reason=$("#mg_employee_leave_types_reason").val();
        if (leave_type==""){// && ((!!from_date && !!to_date) || !!half_day_date) && reason==''){//&& ((from_date=="undefined" && to_date=="undefined") || half_day_date=="undefined")){
          // alert("insde if");
      // && ((from_date==undefined && to_date==undefined) || half_day_date==undefined)){
        // alert("Please fill the mandatory fields...");
                   $('#save_student_data').click(); 

           
      }else{
          // alert("inside else");
         var urlLink = "/mg_employee_leave_types/validate_employee_leave/";
            $.ajax({
                url: urlLink ,
                cache: false,
                data:{leave_type: leave_type, from_date: from_date, to_date: to_date, half_day_date: half_day_date, is_halfday: is_halfday, mg_employee_id: mg_employee_id

                },
                success: function(data){
                   console.log(data.notice);
                  if(data.notice=='successful'){
                   $('#save_student_data').click(); 
                   
                  }else if (data.notice=='from Date should be Greter then to Date'){
                    alert(data.notice);
                    document.getElementById("mg_employee_leave_types_to_date").value = "";
                  }else if (data.notice=='fill_form'){
                   $('#save_student_data').click(); 
                    
                  }else{
                    alert(data.notice);
                    // document.getElementById("mg_employee_leave_types_to_date").value = "";

                  }
                  }
            });
     }
});

$(document).on("click", ".approve-leave-for-employee-cls", function(e){
        var myID =$(this).attr('id');
        var splitID=myID.split("-");
   
                var retVal = confirm("Are you sure to Approve Leave?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/mg_employee_leave_types/leave_action_save/";

                      $.ajax({
                        url: urlLink ,
                        data:{
                          mg_employee_leave_application_id: splitID[0], approve: "approve-leave"
                        },
                        cache: false,
                        success: function(html){
                             
                        }
                    });

                }else{
                   // alert(retVal);     
                   return false;
                }
});

$(document).on("click", ".reject-leave-for-employee-cls", function(e){
        var myID =$(this).attr('id');
        var splitID=myID.split("-");
        // alert("id :"+splitID[0]);
        var urlLink = "/mg_employee_leave_types/leave_action";
        $.ajax({
            url: urlLink ,
             data:{
                      mg_employee_leave_application_id: splitID[0], approve: "reject-leave"
                    },
            cache: false,
            success: function(html){
                  $('#rejectLeaveForEmployeeDIVID').dialog({
                    modal: true,
                    width: 'auto',
                   
                    title: "Leave Action",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
$(document).ready(function () {
    $("#mgEmployeeLeaveTypesID").validate({

    rules: {

    "mg_employee_leave_types[leave_name]": {required: true},

    "mg_employee_leave_types[leave_code]": {required: true},
    "mg_employee_leave_types[max_leave_count]": {required: true, number: true},

    "mg_employee_leave_types[reset_period]": {required: true},
    "mg_employee_leave_types[reset_date]": {required: true}
    }
    });
});

$(document).on("click", ".editLeaveClass", function(e){
    e.preventDefault();
// alert("abc");
        var myID =$(this).attr('id');
         // alert(myID);

       var splString = myID.split("-");
     //  alert(splString);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/mg_employee_leave_types/"+splString[1]+"/edit/";
    //alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editEmployeeLeaveTypeDialogDivID').dialog({
                    modal: true,
                    title: "Edit",
                    minHeight: 500,
                    width: 430,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
//delete

 $(document).on("click", ".deleteLeaveClass", function(e){
    e.preventDefault();
        var myID =$(this).attr('id');


        var splString = myID.split("-");
         // alert(splString);
        var retVal = confirm("Are you sure to delete data?");
        if(retVal){
          //  alert(retVal);
             var urlLink = "/mg_employee_leave_types/delete/"+splString[1];

              $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   window.location.reload();
                               
                }
            });

        }else{
           // alert(retVal);     
           return false;
        }

}); 




   
