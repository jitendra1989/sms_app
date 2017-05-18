
$(document).on("click", ".employee-biometric-attendances-submit-form", function(e){
        e.preventDefault();
        var date=$("#employee_biometric_attendances_date").val();
        var check_in=$("#employee_biometric_attendances_check_in").val();
        var check_out=$("#employee_biometric_attendances_check_out").val();
        var mg_employee_id=$("#mg_employee_id").val();
        console.log("date--->"+date+"check_in---->"+check_in+"check_out---->"+check_out);
        console.log("mg_employee_id--->"+mg_employee_id);
        if(document.getElementById('employee_biometric_attendances_date').value == '') 
             {      
                  alert("Please provide date.");
                  document.getElementById('employee_biometric_attendances_date').focus();

            return false;       
            }
            if(document.getElementById('employee_biometric_attendances_check_in').value == '') 
             {      
                  alert("Please select check in time.");
                  document.getElementById('employee_biometric_attendances_check_in').focus();

            return false;       
            }
            if(document.getElementById('employee_biometric_attendances_check_out').value == '') 
             {      
                  alert("Please select check out time.");
                  document.getElementById('employee_biometric_attendances_check_out').focus();

            return false;       
            }
             if(document.getElementById('mg_employee_department_id').value == '') 
             {      
                  alert("Please select department.");
                  document.getElementById('mg_employee_department_id').focus();

            return false;       
            }

            if(document.getElementById('mg_employee_id').value == '') 
             {      
                  alert("Please select employee.");
                  document.getElementById('mg_employee_id').focus();

            return false;       
            }
            save_biometric_attendances(date,check_in,check_out,mg_employee_id);

          
});


function save_biometric_attendances(date,check_in,check_out,mg_employee_id){
	var urlLink = "/employee_biometric_attendances/create";
        $.ajax({
            url: urlLink ,
            cache: false,
            type: "POST",
            data:{ date: date,
                   check_in: check_in,
                   check_out:check_out,
                   mg_employee_id: mg_employee_id
                  },
            success: function(data){
              console.log("data----->"+data.validation);
               if (data.validation){
                   $(".ui-dialog-titlebar-close").click(); 
                   window.location.reload();
              }else{
                 alert("Time range already exists");
              }
               
            },
            error:function(html){
              // alert("error");

            }
        });
}


$(document).on("click", ".employee-biometric-attendances-edit-submit-form", function(e){
        e.preventDefault();
        var id=$(this).attr("id");
		id =id.split('-');
        var date=$("#employeeBiometricAttendancesDateID").val();
        var check_in=$("#employeeBiometricAttendancesCheck_inID").val();
        var check_out=$("#employeeBiometricAttendancesCheck_outID").val();
        var mg_employee_id=$("#employee_biometric_attendances_mg_employee_id").val();
        console.log("date--->"+date+"check_in---->"+check_in+"check_out---->"+check_out);
        console.log("mg_employee_id--->"+mg_employee_id);
        if(document.getElementById('employeeBiometricAttendancesDateID').value == '') 
             {      
                  alert("Please provide date.");
                  document.getElementById('employeeBiometricAttendancesDateID').focus();

            return false;       
            }
            if(document.getElementById('employeeBiometricAttendancesCheck_inID').value == '') 
             {      
                  alert("Please select check in time.");
                  document.getElementById('employeeBiometricAttendancesCheck_inID').focus();

            return false;       
            }
            if(document.getElementById('employeeBiometricAttendancesCheck_outID').value == '') 
             {      
                  alert("Please select check out time.");
                  document.getElementById('employeeBiometricAttendancesCheck_outID').focus();

            return false;       
            }
            if(document.getElementById('employee_biometric_attendances_mg_employee_id').value == '') 
             {      
                  alert("Please select employee.");
                  document.getElementById('employee_biometric_attendances_mg_employee_id').focus();

            return false;       
            }
            update_biometric_attendances(date,check_in,check_out,mg_employee_id,id[0]);
            

          
});

function update_biometric_attendances(date,check_in,check_out,mg_employee_id,id){
	var urlLink = "/employee_biometric_attendances/"+id;
        $.ajax({
            url: urlLink ,
            cache: false,
            type: "PATCH",
            data:{ date: date,
                   check_in: check_in,
                   check_out:check_out,
                   mg_employee_id: mg_employee_id
                  },
            success: function(data){
              console.log("data----->"+data.validation);
               if (data.validation){
                   $(".ui-dialog-titlebar-close").click(); 
                   window.location.reload();
              }else{
                 alert("Time range already exists");
              }
               
            },
            error:function(html){
              // alert("error");

            }
        });
}

$(document).on("click", ".new-employee-biometric-attendances-btn", function(e){
        // var myID =$(this).attr('id');

        var urlLink = "/employee_biometric_attendances/new";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#newEmployeeBiometricAttendancesDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "New Employee Biometric Attendance",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-employee-biometric-attendances-btn", function(e){
        var myID =$(this).attr('id');
        myID=myID.split('-');
        var urlLink = "/employee_biometric_attendances/"+myID[0]+"/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editEmployeeBiometricAttendancesDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Edit Employee Biometric Attendance",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".show-employee-biometric-attendances-btn", function(e){
        var myID =$(this).attr('id');
         myID=myID.split('-');
        var urlLink = "/employee_biometric_attendances/"+myID[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showEmployeeBiometricAttendancesDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Show Employee Biometric Attendance",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".delete-employee-biometric-attendances-btn", function(e){
     
                var myID =$(this).attr('id');
                 myID=myID.split('-');
                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/employee_biometric_attendances/delete/"+myID[0];

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