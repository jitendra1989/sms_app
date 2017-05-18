$(document).on("click", ".new-event-committees-btn", function(e){
        var urlLink = "/event_committees/new";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#newEventCommitteesDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "New Event Committee",
                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".edit-event-committees-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/event_committees/"+Id[0]+"/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editEventCommitteesDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Edit Event Committee",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".show-event-committees-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/event_committees/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showEventCommitteesDIVID').dialog({
                    modal: true,
                    height: 500,
                    width: 'auto',
                    title: "Show Event Committee",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
            }
        });
});


$(document).on("click", ".delete-event-committees-btn", function(e){
                var myID =$(this).attr('id');
                    var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/event_committees/delete/"+Id[0];
                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(html){
                           window.location.reload();
                        }
                    });
                }else{    
                   return false;
                }

        });




function optionForDepartment(value){
        var committeeID=$("#selectCommitteeSelectTagID").val();
        var urlLink = "/event_committees/employee_list/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{
                mg_event_committee_id: committeeID,
                mg_employee_department_id: value
            },
            success: function(html){
                    $('#employeeListDIVID').empty();
                    $('#employeeListDIVID').append(html);
            }
        });
}

function optionForMembers(value){
     if (value){
       
        var urlLink = "/event_committees/"+value;

        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
            $("#eventCommiteeMembersListDIVID").html(html);
            $(".add-student-to-committee-div-cls").attr("id", value+"-addStudentToCommitteeDivID");
            $(".add-employee-to-committee-div-cls").attr("id", value+"-addStudentToCommitteeDivID");
            $("#memberAssignDivID").show();
            $("#formForEmployeeOrStudentDIVID").empty();
              }
        });

        

     }else{
        $("#memberAssignDivID").hide();
     }


}



$(document).on("click", ".add-employee-to-committee-div-cls", function(e){
        e.preventDefault();
        var committeeID=$("#selectCommitteeSelectTagID").val();
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/event_committees/add_employee_to_commitee/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                   $('#formForEmployeeOrStudentDIVID').empty();
                  $('#formForEmployeeOrStudentDIVID').append(html);
            }
        });
}); 

$(document).on("click", ".add-student-to-committee-div-cls", function(e){
    e.preventDefault();
        
        
        var urlLink = "/event_committees/add_student_to_commitee";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                $("#formForEmployeeOrStudentDIVID").empty();
                $('#formForEmployeeOrStudentDIVID').append(html) 
            }
        });
}); 
function optionForClass(value){

        $("#studentListDIVID").empty();
        var urlLink = "/event_committees/batch_list/"+value;
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                $("#studentBatchListDIVID").empty();
                $('#studentBatchListDIVID').append(html) 
            }
        });
} 

function optionForSection(value){
        var committeeID= $("#selectCommitteeSelectTagID").val();
        var mg_batch_id=$("#mg_batch_id").val();
        var urlLink = "/event_committees/student_list/"+value;
        //alert("mg_batch_id : "+mg_batch_id);
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{
                mg_event_committee_id: committeeID,
                mg_batch_id: mg_batch_id
            },
            success: function(html){
                $("#studentListDIVID").empty();
                $('#studentListDIVID').append(html) 
            }
        });
} 
