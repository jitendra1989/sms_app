 $(document).on("click", "#newEmployeeGradeID", function(e){
    e.preventDefault();
            //   alert("Hi");

                var urlLink = "/mg_employee_grades/new";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);

                         $('#newEmployeeGradesDialogID').dialog({
                          //  modal: true,
                            title: "Create Employee Grade",
                            height: "auto",
                            width: "auto",
                            open: function () {
                                $(this).html(html);
                            }
                     });
                    }
                      
                });
        });



        $(document).on("click", ".edit-employee-grade", function(e){
            e.preventDefault();
         //       alert("osition");
                 var myID =$(this).attr('id');
            var splString = myID.split("-");
           // alert(splString[1]);
            var urlLink = "/mg_employee_grades/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      $('#editEmployeeGradesDialogID').dialog({
                        modal: true,
                        title: "Edit Employee Grade",
                        height: "auto",
                        width: "auto",
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  

        });

        $(document).on("click", ".show-employee-grade", function(e){
            e.preventDefault();
            var myID =$(this).attr('id');
            var splString = myID.split("-");
            var urlLink = "/mg_employee_grades/"+splString[1];
            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){

                      $('#showEmployeeGradesDialogID').dialog({
                        modal: true,
                        title: "Show Employee Grade",
                        height: "auto",
                        width: "auto",
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  

        });
        //

           $(document).on("click", ".delete-employee-grade", function(e){
              e.preventDefault();
                var myID =$(this).attr('id');

                var splString = myID.split("-");
        //        alert(splString);
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/mg_employee_grades/delete/"+splString[1];

                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(data){
                           if (data.validation=="deleted"){
                                window.location.reload();
                           }else{
                                alert("Deletion discarded,this grade is assigned to employees");
                           }
                                       
                        }
                    });

                }else{
                   // alert(retVal);     
                   return false;
                }

        }); 


 $(document).on("click", "#employeeNewGradeFormSubmitBTNID", function(e){
  e.preventDefault();
    var components=0.0;
    $(".validation-compont-grade-new-sun-cls").each(function() {
        components=components+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
    });
     var deduction=0.0;
    $(".validation-is-deduction-grade-new--sun-cls").each(function() {
        deduction=deduction+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
    });

    if(components>=deduction){
        $("#employeeNewGradeHiddenFormSubmitBTNID").click();
      }else{
          alert("Components total shoud be greter then deduction.");
      }
});

  $(document).on("click", "#employeeEditGradeFormSubmitBTNID", function(e){
  e.preventDefault();
    var components=0.0;
    $(".validation-compont-grade-edit-sun-cls").each(function() {
        components=components+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
    });
     var deduction=0.0;
    $(".validation-is-deduction-grade-edit--sun-cls").each(function() {
        deduction=deduction+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
    });

    if(components>=deduction){
        $("#employeeEditGradeHiddenFormSubmitBTNID").click();
      }else{
          alert("Components total shoud be greter then deduction.");
      }
});


