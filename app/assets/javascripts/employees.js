/* comm */


$(document).on("click", "#employeeSearchBtnID", function(e){
    var searchForData = $("#employeeSearchBoxID").val();
   // alert("Hello -- "+searchForData.length);

    if(searchForData.length > 0){
        //  alert("Hello -- "+searchForData.length);
        var urlLink = "/employees/search_employee_data/";
        $.ajax({
                url: urlLink ,
                cache: false,
                data:{searchData: searchForData },
                success: function(data){
                    console.log(data.length);
                    if(data.length > 0){
                       var apdStr ='<table class="batch-tbl">';
                            apdStr +=        '<tr class="employee-table-header">';
                            apdStr +=        '<th>Employee Name</th>';
                            apdStr +=        '<th>Job title</th>';
                            apdStr +=        '<th>Qualification</th>';
                            apdStr +=       '</tr>' ;

                    for(key in data){
                         apdStr +='<tr class="even">';
                         apdStr += '<td>'+data[key].first_name+ " " +data[key].last_name+'</td>';
                         apdStr += '<td>'+data[key].job_title+'</td>';
                         apdStr += '<td>'+data[key].qualification+'</td>';
                         apdStr += '</tr>';

                    }
                    apdStr += '</table>';

                    $("#searchEmployeeDataID").empty().append(apdStr);
                    }else{
                      alert("No students found");   
                    }
                  //  alert("Success");
                },
                error: function(){
                  //  alert("error");
                }

           });   
    }else{
        alert("Please enter some value for search");
    }
        



});




$(document).ready(function(e){
    $(document).on("click", ".show-employee", function(e){ 
    
// $(document).on("click", ".Exam-Fa-Class", function(e){
        var myID =$(".view-div").attr('id');
     
        // alert(myID);

        var urlLink = "/employees/show/"+myID;
        // alert(urlLink);
        // alert(myID);
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                // alert("success");
            $("#breadcrumbs-Ids").empty();
            $("#breadcrumbs-Ids").append(html);
               
            }
        });
// });
});

});
     $(document).ready(function(){


  

        //$(document).on("validate",".new_mg_employee_category",);

       
       /* // var urlLink = "/employees/manage_employees";
        // $.ajax({
        //     url: urlLink ,
        //     cache: false,
        //     success: function(html){
        //         console.log(html);
        //         //$(this).removeClass("header");
        //         $("#manageEmployeeForm").empty();
        //         $("#manageEmployeeForm").append(html);
        //     }
                
        // });



        //  $(document).on("click", "#viewEmployeeList", function(e){
        //      var urlLink = "/employees/manage_employees";
        // $.ajax({
        //     url: urlLink ,
        //     cache: false,
        //     success: function(html){
        //        // console.log(html);
        //         //$(this).removeClass("header");
        //         $("#manageEmployeeForm").empty();
        //         $("#manageEmployeeForm").append(html);
        //     }
                
        // });
        // });



         // $(document).on("click", "#createnNewEmployee22", function(e){
         // //   alert("Create new employee");
         //        var urlLink = "/employees/new";
         //        $.ajax({
         //            url: urlLink ,
         //            cache: false,
         //            success: function(html){
         //                // alert("Successc is comming");
         //                //$(this).removeClass("header");
         //                $("#manageEmployeeForm").empty();
         //                $("#manageEmployeeForm").append(html);
         //            }
                        
         //        });  

         //  });  
*/

$(document).on("click", ".edit-employee-custum-fields", function(e){
        e.preventDefault();

        var customFieldId =$(this).attr("id");
        var id=customFieldId.split("-");
        // alert("Id : "+Id[1]);
        var urlLink = "/employees/custom_fields_edit/"+id[1];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html)
            {
                  $('#editEmployeeCustomFieldDialogID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    minWidth: 'auto',
                    title: "Edit Employee Custom Field",

                    open: function () 
                    {
                        $(this).html(html);
                    }
                }); 
            }
        });
});
            $(document).on("click", ".show-employee", function(e){   
            var myID =$(this).attr('id');
            var splString = myID.split("-");
            var urlLink = "/employees/show/"+splString[1];
            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/
              $("#manageEmployeeForm").empty();
               $("#manageEmployeeForm").append(html);
                }
            });  
        });
         $(document).on("click", ".edit-employee", function(e){   

            var myID =$(this).attr('id');
            var splString = myID.split("-");
          
            var urlLink = "/employees/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      //$('<div style="padding: 2px;"></div>').dialog({
                        $("#editEmployeeDialog").dialog({
                        modal: true,
                        title: "Edit Employee",
                        height: 640,
                        minWidth: 860,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  



        }); 

        $(document).on("click", ".delete-employee", function(e){   
                           
                var myID =$(this).attr('id');

                var splString = myID.split("-");
             //   alert(splString);
                var retVal = confirm("Are you sure to delete employee?");
                if(retVal){
                   // alert(retVal);
                     var urlLink = "/employees/delete/"+splString[1];

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

         $(document).on("click", "#manageEmployeeCategory33", function(e){  
              //  alert("retVal");

              //  var urlLink = "/mg_employee_categories/show";
                var urlLink = "/mg_employee_categories";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){

                        //$(this).removeClass("header");
                        $("#manageEmployeeForm").empty();
                        $("#manageEmployeeForm").append(html);
                    }
                        
                });
        });

         $(document).on("click", "#newEmployeeCategoryID", function(e){
              //  alert("newEmployeeCategoryID");

                var urlLink = "/mg_employee_categories/new";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);

                         $('#newEmployeeCategoryDialogID').dialog({
                          //  modal: true,
                            title: "Add Employee Category",
                            minHeight: 300,
                            minWidth: 250,
                            open: function () {
                                
                                $(this).html(html);
                            }
                     });
                    }
                      
                });
        });

          $(document).on("click", "#CategoryFormID", function() {


            // comment line coz validation was not working
           // $(".ui-dialog-content").dialog("close");
            //$("#newEmployeeCategoryDialogID").dialog('close');
         });

         // $(document).on("submit", "#new_mg_employee_category", function() {

         //       $.ajax({
         //          url: $(this).attr("action"),
         //          data: $(this).serialize(),
         //          success: function(data) {
         //             // do something here
         //             $("#newEmployeeCategoryDialogID").dialog('close');
         //          }
         //       });
         //    });

            // $('#new_mg_employee_category').on('ajax:beforeSend', function(evt, xhr, settings){
            //   // prevent double submit
            //   alert("hello");
            //   $(':submit', this).click(function() {
            //     return false;
            //   });
            // });

         // $(document).on("submit", "#new_mg_employee_category", function() {

         //       $.ajax({
         //          url: $(this).attr("action"),
         //          data: $(this).serialize(),
         //          success: function(data) {
         //             // do something here
         //             $("#newEmployeeCategoryDialogID").dialog('close');
         //          }
         //       });
         //    });


         $(document).on("click", ".edit-employee-category", function(e){
             //   alert("edit");
                 var myID =$(this).attr('id');
            var splString = myID.split("-");
           // alert(splString[1]);
            var urlLink = "/mg_employee_categories/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      $('#editEmployeeCategoryDialogID').dialog({
                        modal: true,
                        title: "Edit Employee Category",
                        minHeight: 300,
                        minWidth: 250,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  

        });

          $(document).on("click", ".delete-employee-category", function(e){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
              //  alert(splString);
                var retVal = confirm("Are you sure to delete category?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/mg_employee_categories/delete/"+splString[1];

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


      
           // AD NEW 
        $(document).on("click", "#newEmployeeDepartmentID", function(e){
            //   alert("Hi");

                var urlLink = "/mg_employee_departments/new";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);

                         $('#newEmployeeDepartmentDialogID').dialog({
                          //  modal: true,
                            title: "Add Employee Department",
                            minHeight: 200,
                            minWidth: 250,
                            open: function () {
                                $(this).html(html);
                            }
                     });
                    }
                      
                });
        }); 
      // update
         $(document).on("click", ".edit-employee-department", function(e){
             //   alert("edit");
                 var myID =$(this).attr('id');
            var splString = myID.split("-");
           // alert(splString[1]);
            var urlLink = "/mg_employee_departments/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      $('#editEmployeeDepartmentDialogID').dialog({
                        modal: true,
                        title: "Edit Employee department",
                        minHeight: 200,
                        minWidth: 250,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  

        });

        // delete 
   
                   $(document).on("click", ".delete-employee-department", function(e){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
                //alert(splString);
                var retVal = confirm("Are you sure to delete department?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/mg_employee_departments/delete/"+splString[1];

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

         $(document).on("click", "#manageEmployeeDepartment_dfdfdfdf", function(e){  
               // alert("retVal");
                
                var urlLink = "/mg_employee_departments/show";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){

                        //$(this).removeClass("header");
                        $("#manageEmployeeForm").empty();
                        $("#manageEmployeeForm").append(html);
                    },
                    buttons: {
                        Submit: function () {
                             // put validations
                            //  'batches_name'
                              
                              addCategory();
                           

                        },
                        Close: function () {
                           $(this).dialog("close");
                        }
                    }
                        
                });
        });
        // newEmployeePositionID

        $(document).on("click", "#newEmployeePositionID", function(e){
            //   alert("Hi");

                var urlLink = "/mg_employee_positions/new";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);

                         $("#newEmployeePositionDialogID").dialog({
                          //  modal: true,
                            title: "Add Employee Profile",
                            minHeight: 250,
                            minWidth: 250,
                            open: function () {
                                $(this).html(html);
                            }
                     });
                    }
                      
                });
        });
        
        $(document).on("click", ".edit-employee-position", function(e){
         //       alert("osition");
                 var myID =$(this).attr('id');
            var splString = myID.split("-");
           // alert(splString[1]);
            var urlLink = "/mg_employee_positions/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      $('<div></div>').dialog({
                        modal: true,
                        title: "Edit Employee Profile",
                        minHeight: 250,
                        minWidth: 250,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  

        });
        //

           $(document).on("click", ".delete-employee-position", function(e){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
             //   alert(splString);
                var retVal = confirm("Are you sure to delete the selected entry?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/mg_employee_positions/delete/"+splString[1];

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


           // Employee Grades





     $(document).on("click", ".delete-employee-custum-field", function(e){
            var myID =$(this).attr('id');

            var splString = myID.split("-");
          //  alert(splString);
            var retVal = confirm("Are you sure to delete data?");
            if(retVal){
              //  alert(retVal);
                 var urlLink = "/employees/custum_fields_delete/"+splString[1];

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



     /*Language Work Javascript*/



      // Read work start here

      $(document).on('change','.mg-language-speak-radio input[type="checkbox"]', function() {

         $(this).siblings('.mg-language-speak-radio input[type="checkbox"]').not(this).prop('checked', false);

          var labelText = $(this).prev('label').text();
          var trRow = $(this ).parent().parent().parent().prev('tr').children('td');
          var currFlag = trRow.children('.mg-language-speak-checkbox').prop('checked');

          if(!currFlag){
             var parentInputValue = $(this ).parent().parent().parent().prev('tr').prev('tr').prev('tr').children('td').children('input').val(); 

             if(parentInputValue.length == 0){
              $(this).prop('checked',false)
              alert("Please enter language Name");
              
              return;
             }
             else{

            trRow.children('.mg-language-speak-checkbox').val(parentInputValue +"$" +labelText.trim());

             }
            trRow.children('.mg-language-speak-checkbox').prop('checked',true);
            // and set the value
            // console.log();
          }else{

            if ($(this).prop('checked')) {
                          var currentValue = trRow.children('input').val();

                if(currentValue.length > 0){
                  console.log("Inside true ");
                  var changeTo = currentValue.split("$");
                  trRow.children('.mg-language-speak-checkbox').val(changeTo[0] +"$" +labelText.trim());
                }else{
                  console.log("Inside else speak");

                }

            }else{
            trRow.children('.mg-language-speak-checkbox').prop('checked',false);
            trRow.children('.mg-language-speak-checkbox').val("");

            }
           

          }



      });

    $(document).on("change",".mg-language-speak-checkbox",function(event){
          
          event.preventDefault();
          var currentFlagIS = $(this).prop('checked');
          if(currentFlagIS){
                 var langName = $(this).parent().parent().prev('tr').prev('tr').children('td').children('input').val();
            //var langName = $(this ).parent().parent().parent().children(':nth-child(2)').children('td').children('input').val();
            if(langName.length > 0){
              var tagName = $(this ).parent().parent().next().children(':nth-child(1)').children(':nth-child(1)').children(':nth-child(2)').prop('checked',true);
              $(this).val(langName+"$"+"Beginner");
            }else{
              alert("Please enter language name.");
              $(this).prop( "checked", false );
            }

          }else{
              var tagName = $(this ).parent().parent().next().children(':nth-child(1)').children(':nth-child(1)').children(':nth-child(2)').prop('checked',false);
              var tagName = $(this ).parent().parent().next().children(':nth-child(1)').children(':nth-child(1)').children(':nth-child(4)').prop('checked',false);
              var tagName = $(this ).parent().parent().next().children(':nth-child(1)').children(':nth-child(1)').children(':nth-child(6)').prop('checked',false);
              console.log($(this ).parent().parent().next().children(':nth-child(1)').children(':nth-child(1)'));
              $(this).val("");
          }
        

    });

    // End read work

    // Start read work

      $(document).on('change','.mg-language-read-radio input[type="checkbox"]', function() {

                //alert("Step -- 1")

                 $(this).siblings('.mg-language-read-radio input[type="checkbox"]').not(this).prop('checked', false);

                  var labelText = $(this).prev('label').text();
                  var trRow = $(this ).parent().parent().parent().prev('tr').children('td').next().first();
                  // var trRow = $(this ).parent().parent().parent().prev('tr').children('td :nth-child(2)');

                  var currFlag = trRow.children('.mg-language-read-checkbox').prop('checked');
                  console.log("shil")  
                  // console.log($(this ).parent().parent().parent().prev('tr').children('td'))
                  //          console.log("shil -2") 
                  // console.log($(this ).parent().parent().parent().prev('tr').children('td :nth-child(2)'));
                  console.log($(this ).parent().parent().parent().prev('tr').children('td').next().first().children('.mg-language-read-checkbox'));
                 // alert(" Current Flag "+currFlag);  
                  if(!currFlag){
                    var parentInputValue = $(this ).parent().parent().parent().prev('tr').prev('tr').prev('tr').children('td').children('input').val();
                                 console.log(parentInputValue.length);
                       if(parentInputValue.length == 0){
                        $(this).prop('checked',false)
                        alert("Please enter Language Name");
                        
                        return;
                       }
                       else{ 
                        console.log(trRow.html())  
                        trRow.children('.mg-language-read-checkbox').val(parentInputValue +"$" +labelText.trim());

                       }
                       trRow.children('.mg-language-read-checkbox').prop('checked',true);


                  }else{
                     //alert("Step -- else")
                       if ($(this).prop('checked')) {
                          var currentValue = trRow.children('input').val();

                          if(currentValue.length > 0){
                            console.log("Inside true ");
                            var changeTo = currentValue.split("$");
                            trRow.children('.mg-language-read-checkbox').val(changeTo[0] +"$" +labelText.trim());
                          }else{
                            console.log("Inside else read");

                          }

                      }else{
                      trRow.children('.mg-language-read-checkbox').prop('checked',false);
                      trRow.children('.mg-language-read-checkbox').val("");

                      }
                  }

              });

            $(document).on("change",".mg-language-read-checkbox",function(event){
                event.preventDefault();

                var currentFlagIS = $(this).prop('checked');
                if(currentFlagIS){

                  var langName = $(this ).parent().parent().parent().children(':nth-child(2)').children('td').children('input').val();
              
                  if(langName.length > 0){
                    // Change this line according to jquery
                    //var writeElement = event.target.parentElement.parentElement.parentElement.children[2].cells[2].children[0]
                    
                    var tagName = $(this ).parent().parent().next().children(':nth-child(2)').children(':nth-child(1)').children(':nth-child(2)').prop('checked',true);
    
                    $(this).val(langName+"$"+"Beginner");
                  }else{
                    alert("Please enter language name.");
                    $(this).prop( "checked", false );
                  }
                }else{
                      var tagName = $(this ).parent().parent().next().children(':nth-child(2)').children(':nth-child(1)').children(':nth-child(2)').prop('checked',false);
                      var tagName = $(this ).parent().parent().next().children(':nth-child(2)').children(':nth-child(1)').children(':nth-child(4)').prop('checked',false);
                      var tagName = $(this ).parent().parent().next().children(':nth-child(2)').children(':nth-child(1)').children(':nth-child(6)').prop('checked',false);

                      $(this).val("");

                }


            });

    // end write work

    // Start speak work

          $(document).on('change','.mg-language-write-radio input[type="checkbox"]', function() {
                  $(this).siblings('.mg-language-write-radio input[type="checkbox"]').not(this).prop('checked', false);

                  var labelText = $(this).prev('label').text();
               //   var trRow = $(this ).parent().parent().parent().prev('tr').children('td');
                  var trRow = $(this ).parent().parent().parent().prev('tr').children('td').next().last();
                  // var trRow = $(this ).parent().parent().parent().prev('tr').children('td :nth-child(3)');

                  var currFlag = trRow.children('.mg-language-write-checkbox').prop('checked');

                  if(!currFlag){
                    var parentInputValue = $(this ).parent().parent().parent().prev('tr').prev('tr').prev('tr').children('td').children('input').val();
                                 console.log(parentInputValue.length);
                       if(parentInputValue.length == 0){
                        $(this).prop('checked',false)
                        alert("Please enter language Name");
                        
                        return;
                       }
                       else{ 
                        console.log(trRow.html())  
                        trRow.children('.mg-language-write-checkbox').val(parentInputValue +"$" +labelText.trim());

                       }
                       trRow.children('.mg-language-write-checkbox').prop('checked',true);


                  }else{
                                           if ($(this).prop('checked')) {
                          var currentValue = trRow.children('input').val();

                          if(currentValue.length > 0){
                            console.log("Inside true ");
                            var changeTo = currentValue.split("$");
                            trRow.children('.mg-language-write-checkbox').val(changeTo[0] +"$" +labelText.trim());
                          }else{
                            console.log("Inside else read");

                          }

                      }else{
                      trRow.children('.mg-language-write-checkbox').prop('checked',false);
                      trRow.children('.mg-language-write-checkbox').val("");

                      }
                  }
              });

            $(document).on("change",".mg-language-write-checkbox",function(event){
                event.preventDefault();

                var currentFlagIS = $(this).prop('checked');
                if(currentFlagIS){

                    var langName =  $(this ).parent().parent().parent().children(':nth-child(2)').children('td').children('input').val();

                    if(langName.length > 0){
                     
                    var tagName = $(this ).parent().parent().next().children(':nth-child(3)').children(':nth-child(1)').children(':nth-child(2)').prop('checked',true);

                      $(this).val(langName+"$"+"Beginner");
                    }else{
                      alert("Please enter language name.");
                      $(this).prop( "checked", false );
                    }

                }else{

                      var tagName = $(this ).parent().parent().next().children(':nth-child(3)').children(':nth-child(1)').children(':nth-child(2)').prop('checked',false);
                      var tagName = $(this ).parent().parent().next().children(':nth-child(3)').children(':nth-child(1)').children(':nth-child(4)').prop('checked',false);
                      var tagName = $(this ).parent().parent().next().children(':nth-child(3)').children(':nth-child(1)').children(':nth-child(6)').prop('checked',false);

                      $(this).val("");
                }
            });



        $(document).on("click", "#languageEditPlusId", function(){
        

            /*var cloneDiv=$(".languagedivcloneclass").first();

             // console.log(cloneDiv);
             $(cloneDiv).clone().appendTo("#languagedivscloneid");

            var cloneDivLast=$(".languagedivcloneclass").last();

            $(cloneDivLast).children().find('input,checkbox').each(function(){
                $(this).val('');
                $(this).attr("checked",false);
            });*/

            var cloneDiv=$(".cloneLanguageDivId").first();
            var clonedDivForAppend=$(cloneDiv).clone();
            $(clonedDivForAppend).children().find('input,checkbox').each(function(){
                $(this).val('');
                $(this).attr("checked",false);
            });
            $("#languagedivscloneid").append(clonedDivForAppend);



        });
     /*Language Work Javascript*/

    });


$(document).on("click", "#emps_edit_file", function(e){

    var lastRepeatingGroup = $('.employees_edits-file-file-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".emps-edits-remove-file", function(e){

   var total = $('.emps-edits-remove-file').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});





$(document).on("click", "#employeesditaddfilesuploads", function(e){

    var lastRepeatingGroup = $('.emp-edit-files-upload-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

$(document).on("click", ".emp-edit-removes-files-upload", function(e){

   var total = $('.emp-edit-removes-files-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});


$(document).on("click", "#emp_add_file_uploads", function(e){

    var lastRepeatingGroup = $('.emp-file-file-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".emp-remove-file-upload", function(e){

   var total = $('.emp-remove-file-upload').length
   //if(total!=1)
   //{
        $(this).parent('div').remove();
   // }
   //alert($(this).val());
});







$(document).on("click", "#employees_add_files_uploads", function(e){

    var lastRepeatingGroup = $('.emp-files-upload-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".employees-removes-files-upload", function(e){

   var total = $('.employees-removes-files-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});



  $(document).on("click", ".new-salary-components-btn", function(e){
    e.preventDefault();
        var urlLink = "/employees/salary_components_new";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#newSalaryComponentsDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Create Salary Component",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-salary-components-btn", function(e){
    e.preventDefault();
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/employees/salary_components_edit/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editSalaryComponentsDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Edit Salary Component",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

// $(document).on("click", ".show-event-type-btn", function(e){
    // e.preventDefault();
//         var myID =$(this).attr('id');
//         var Id=myID.split("-");



//         var urlLink = "/event_types/"+Id[0];
//         $.ajax({
//             url: urlLink ,
//             cache: false,
//             success: function(html){
//                   $('#showEventTypeDIVID').dialog({
//                     modal: true,
//                     minHeight: 'auto',
//                     width: 'auto',
//                     title: "Show Event Types",
//                     open: function () {
                        
//                         $(this).html(html);
//                     }
//                 }); 
               
//             }
//         });
// });


$(document).on("click", ".delete-salary-components-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
                    var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/employees/salary_components_delete/"+Id[0];

                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(data){
                           // window.location.reload();
                           if (data.validation=="deleted"){
                                window.location.reload();
                           }else{
                                alert("Deletion discarded,this component is assigned to employees");
                           }
                                       
                        }
                    });

                }else{
                   // alert(retVal);     
                   return false;
                }

        }); 

  
$(document).on("change", "#account_details_account_number", function(e){
    e.preventDefault();
        var urlLink = "/employees/validate_accout_no";
        var myID =this.value;
        $.ajax({
            url: urlLink ,
            data :{account_number: myID },
            cache: false,
            success: function(html){
                  // alert(html.validation);
                  if (html.validation){
                    alert("account number already exists ");
                     document.getElementById('account_details_account_number').focus();
                  }
            }
        });
});

var count_employee_submit_form=true;
// $("#clickFormBtnId").click(function(){
$(document).on("click", "#clickFormBtnId", function(e){
    e.preventDefault();
     // alert(); 
     var isDisabled = $("#submitEmployeeFormBtnId").is(':disabled');
if(isDisabled){
    console.log("disabled");
}else{
 console.log("not-disabled");
  if($("#employeeNewFormID").valid()){

        if (count_employee_submit_form){
            count_employee_submit_form=false;
          var empFirstName=$("#employee_first_name").val().trim();
          var empLastName=$("#employee_last_name").val().trim();
          var empDOB=$("#employee_date_of_birth").val().trim();
          var empFatherName=$("#employee_father_name").val().trim();
          var accountNumber=$("#account_details_account_number").val();
          var ifsc=$("#account_details_ifs_code").val();
          //var empId=$("#currentEmployeeId").val();
          var urlLink="/employees/verify_employee_record";
          if( empFirstName=="" || empLastName=="" || empDOB=="" || empFatherName=="" || accountNumber=='' || ifsc=='') {
            $("#submitEmployeeFormBtnId").click();
            count_employee_submit_form=true;
          } else {
            $.ajax({
                  url: urlLink ,
                  dataType: "json",
                  cache: false,
                  data:{
                    empFirstName:  empFirstName,
                    empLastName:   empLastName,
                    empDOB:        empDOB,
                    empFatherName: empFatherName,
                    empId        : '',
                    varifyEmpRecord: "employee_new",
                    account_number: accountNumber,
                    ifs_code: ifsc
                  },
                  success: function(data){
                    console.log("data");
                    console.log(data.empObj);
                    console.log(data.empObj.length);
                    console.log(data.account_details);

                    if (data.account_details){
                       alert("Combination of ifs code and account number already exists ");
                       document.getElementById('account_details_account_number').focus();
                       count_employee_submit_form=true;
                    }else{
                      if(data.empObj.length>0){
                        alert("User already exists.");
                        count_employee_submit_form=true;
                      }
                      else if(data.rescue_empObj.length>0){ 
                        alert(data.rescue_empObj);
                        count_employee_submit_form=true;
                      }
                        
                      else {
                        $("#submitEmployeeFormBtnId").click();
                        $('#submitEmployeeFormBtnId').prop('disabled', true);
                        count_employee_submit_form=true;

                      }
                    }
                    
                  }
            });
          }

        }

  }else{
      $("#submitEmployeeFormBtnId").click();
  }
 
}
});


var count_employee_submit_form_edit=true;
// $("#clickFormBtnId").click(function(){
$(document).on("click", "#clickFormEditBtnId", function(e){
// alert(count_employee_submit_form_edit);
    e.preventDefault();

// var isDisabled = $("#submitEmployeeFormBtnId").is(':disabled');
// alert(isDisabled);
var isDisabled = $("#submitEmployeeFormBtnId").is(':disabled');
if(isDisabled){
    console.log("disabled");
}else{
 console.log("not-disabled");
 if($("#elm_id").valid()) {
    // alert(); 
                  if (count_employee_submit_form_edit){
                    count_employee_submit_form_edit=false;
                  var empFirstName=$("#employee_first_name").val().trim();
                  var empLastName=$("#employee_last_name").val().trim();
                  var empDOB=$("#employee_date_of_birth").val().trim();
                  var empFatherName=$("#employee_father_name").val().trim();
                  var empId=$("#currentEmployeeId").val();
                  var accountNumber=$("#account_details_account_number").val();
                  var ifsc=$("#account_details_ifs_code").val();
                  //var empId=$("#currentEmployeeId").val();
                  var urlLink="/employees/verify_employee_record";
                  if( empFirstName=="" || empLastName=="" || empDOB=="" || empFatherName=="" || accountNumber=='' || ifsc=='') {
                    $("#submitEmployeeFormBtnId").click();
                    count_employee_submit_form_edit=true;
                  } else {
                    $.ajax({
                          url: urlLink ,
                          dataType: "json",
                          cache: false,
                          data:{
                            empFirstName:  empFirstName,
                            empLastName:   empLastName,
                            empDOB:        empDOB,
                            empFatherName: empFatherName,
                            empId        : empId,
                            varifyEmpRecord: "employee_edit",
                            account_number: accountNumber,
                            ifs_code: ifsc
                          },
                          success: function(data){
                            console.log("data");
                            console.log(data.empObj);
                            console.log(data.empObj.length);
                            console.log(data.account_details);

                            if (data.account_details){

                               alert("Combination of ifs code and account number already exists ");
                               document.getElementById('account_details_account_number').focus();
                                count_employee_submit_form_edit=true;

                            }else{
                              if(data.empObj.length>0){
                                alert("User already exists.");
                                count_employee_submit_form_edit=true;
                              }
                              else if(data.rescue_empObj.length>0){ 
                                alert(data.rescue_empObj);
                                count_employee_submit_form_edit=true;
                              }
                                
                              else {
                                $("#submitEmployeeFormBtnId").click();
                                $('#submitEmployeeFormBtnId').prop('disabled', true);
                                count_employee_submit_form_edit=true;

                              }
                            }
                            
                          }
                    });
                  }

                }

    }else{
        $("#submitEmployeeFormBtnId").click();
    }
}
});

// $('my-link').observe('click', function (event) {
//   alert('Hooray!');
//   event.stop(); // Prevent link from following through to its given href
// });