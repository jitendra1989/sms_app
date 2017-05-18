/* comm */

 $(document).ready(function(){
    // var urlLink = "/students/manage_students";
    // $.ajax({
    //     url: urlLink ,
    //     cache: false,
    //     success: function(html){
    //         console.log(html);
    //         //$(this).removeClass("header");
    //         $("#manageStudentCategoryID").empty();
    //         $("#manageStudentCategoryID").append(html);
    //     }
            
    // });



});
 
$(document).on("click", ".edit-remove-file-upload", function(e){

   var total = $('.edit-remove-file-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});

$(document).on("click", "#editaddfileuploads", function(e){

    var lastRepeatingGroup = $('.edit_file_div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".edit-removes-files-upload", function(e){

   var total = $('.edit-removes-files-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});

$(document).on("click", "#editaddfilesuploads", function(e){

    var lastRepeatingGroup = $('.edits_uploads_div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

$(document).on("click", ".edit-remove-files-uploads", function(e){

   var total = $('.edit-remove-files-uploads').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});

$(document).on("click", "#editaddsfileuploads", function(e){

    var lastRepeatingGroup = $('.files-edit-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

$(document).on("click", ".edits-removes-files-uploads", function(e){

   var total = $('.edits-removes-files-uploads').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});

$(document).on("click", "#editsaddfileupload", function(e){

    var lastRepeatingGroup = $('.due-fine-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 






$(document).on("click", "#studentSearchBtnID", function(e){
    var searchForData = $("#studentSearchBoxID").val();
 //   alert("Hello -- "+searchForData.length);

    if(searchForData.length > 0){
        var urlLink = "/students/search_student_data/";
        $.ajax({
                url: urlLink ,
                cache: false,
                data:{searchData: searchForData },
                success: function(data){
                    console.log(data.length);
                    if(data.length > 0){
                       var apdStr ='<table class="batch-tbl">';
                            apdStr +=        '<tr class="student-table-header">';
                            apdStr +=        '<th>Student Name</th>';
                            apdStr +=        '<th>Admission Number</th>';
                            apdStr +=        '<th>Gender</th>';
                            apdStr +=       '</tr>' ;

                    for(key in data){
                         apdStr +='<tr class="even">';
                         apdStr += '<td>'+data[key].first_name+'</td>';
                         apdStr += '<td>'+data[key].admission_number+'</td>';
                         apdStr += '<td>'+data[key].gender+'</td>';
                         apdStr += '</tr>';

                    }
                    apdStr += '</table>';

                    $("#searchStudentDataID").empty().append(apdStr);
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
$(document).on("click", ".add-student-parent", function(e){

    e.preventDefault();
    var myID =$(this).attr('id');
    var splString = myID.split("-");

    window.CurrentStudentID = splString[1];

    var urlLink = "/guardians/new_guardian/"+splString[1];
   // alert(urlLink + "from morning");
    $.ajax({

            url: urlLink ,
            cache: false,
            success: function(html){
//<div class="fancybox-outer"  id="addParentDialogID" style="padding: 2px; width: auto; height: auto;"></div>


                  $('#addParentDialogID').dialog({
                    modal: true,
                    height: 640,
                    minWidth: 860,
                    title: "Add Guardian",

                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }

       });     
});
$(document).on("click", "#addStudentCategoriesID", function(e){

    //alert("hello");
    var urlLink = "/student_categories/new/";
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){
            $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                modal: true,
                title: "Create New Student Category",
                open: function () {
                    $(this).html(html);
                }
            }); 
        }
    });
});



$(document).on("click", ".delete-student", function(e){
        //alert("delete");

                var myID =$(this).attr('id');

                var splString = myID.split("-");
             //   alert(splString);
                var retVal = confirm("Are you sure to delete student?");
                if(retVal){
                   // alert(retVal);
                     var urlLink = "/students/delete/"+splString[1];

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
$(document).on("click", ".edit-student", function(e){
   // alert("Studetn edit");
    var myID =$(this).attr('id');
    var splString = myID.split("-");



    var urlLink = "/students/"+splString[1]+"/edit";
        // alert(Id[1]);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editStudentDialogID').dialog({
                    modal: true,
                    //minHeight: 650,
                    height: 640,
                    minWidth: 860,
                    title: "Edit Student",

                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }
    });
});




$(document).on("click", ".edit-student-category", function(e){
        //var studentCategoryID =$(this).attr('id');
        //alert(studentCategoryID);
        var myID =$(this).attr('id');
        var splString = myID.split("-");


        // var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/student_categories/edit/"+splString[1];
   //     alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    modal: true,
                    title: "Edit Student Category",
                    open: function () {
                    
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", "#viewStudentList_demo", function(e){

    //alert("hello");
    var urlLink = "/students/manage_students";
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){
            console.log(html);
            //$(this).removeClass("header");
            $("#manageStudentCategoryID").empty();
            $("#manageStudentCategoryID").append(html);
        }
            
    });
});

$(document).on("click", "#viewGuardiantList_demo", function(e){

    $("#manageStudentCategoryID").empty();
});

$(document).on("click", ".edit-student-custum-fields", function(e){

        e.preventDefault();

        var customFieldId =$(this).attr("id");
        var id=customFieldId.split("-");
        // alert("Id : "+Id[1]);
        var urlLink = "/students/custom_fields_edit/"+id[1];

        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html)
            {
                  $('#editStudentCustomFieldsDivID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    minWidth: 'auto',
                    title: "Edit Student Custom Field",

                    open: function ()
                    {
                        $(this).html(html);
                    }
                }); 
            }
        });
});


$(document).on("click", ".delete-student-custum-field", function(e){
            var myID =$(this).attr('id');

            var splString = myID.split("-");
          //  alert(splString);
            var retVal = confirm("Are you sure to delete custom-field?");
            if(retVal){
              //  alert(retVal);
                 var urlLink = "/students/custum_fields_delete/"+splString[1];

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





//$(document).on("click", "#createNewStudentCategory", function(e){

    //$("li").removeClass( "active" );
    //$("a").removeClass( "activeMenu" );
    //$("div").removeClass("header");

    // var urlLink = "/student_categories";
    // $.ajax({
    //     url: urlLink ,
    //     cache: false,
    //     success: function(html){

    //         //$(this).removeClass("header");
    //         $("#manageStudentCategoryID").empty();
    //         $("#manageStudentCategoryID").append(html);
    //     }
            
    // });
//});

// function removeClassStudentForm(){
//         // Removing class from Li
//     $("#createNewStudentLiID").removeClass( "active" );
//     $("#viewStudentListLiId").removeClass( "active" );
//     $("#createNewStudentCategoryLiID").removeClass( "active" );
//     $("#viewGuardiantListLiId").removeClass( "active" );
//     // Removing class from A
//     $("#viewStudentListAId").removeClass( "activeMenu" );
//     $("#createNewStudentAID").removeClass( "activeMenu" );
//     $("#createNewStudentCategoryAID").removeClass( "activeMenu" );
//     $("#viewGuardiantListAId").removeClass( "activeMenu" );
    
// }

// $(document).on("click", "#createNewStudentAID", function(e){

//      removeClassStudentForm();
//     // Adding class 
//     $("#createNewStudentAID").addClass( "activeMenu" );
//     $("#createNewStudentLiID").addClass( "active" );

// });

// $(document).on("click", "#viewStudentListAId", function(e){

//      removeClassStudentForm();
//     // Adding class 
//     $("#viewStudentListAId").addClass( "activeMenu" );
//     $("#viewStudentListLiId").addClass( "active" );

// });
// $(document).on("click", "#createNewStudentCategoryAID", function(e){

//      removeClassStudentForm();
//     // Adding class 
//     $("#createNewStudentCategoryAID").addClass( "activeMenu" );
//     $("#createNewStudentCategoryLiID").addClass( "active" );

// });
// $(document).on("click", "#viewGuardiantListAId", function(e){
//     alert("List of g");
//      removeClassStudentForm();
//     // Adding class 
//     $("#viewGuardiantListAId").addClass( "activeMenu" );
//     $("#viewGuardiantListLiId").addClass( "active" );

// });


//$(document).on("click", "#createNewStudentAID", function(e){
     

     
     

    //alert("hello");
    //$("li").removeClass( "active" );
    //
    //$("div").removeClass("header");

    // var urlLink = "/students/new";
    // $.ajax({
    //     url: urlLink ,
    //     cache: false,
    //     success: function(html){

    //         //$(this).removeClass("header");
    //         $("#manageStudentCategoryID").empty();
    //         $("#manageStudentCategoryID").append(html);
    //     }
            
    // });
//});


$(document).on("click", "#add_file_student_uploads", function(e){

    var lastRepeatingGroup = $('.student_file_file_div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".studentfile-upload", function(e){

   var total = $('.studentfile-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
  
});

$(document).on("click", "#add_files_uploads", function(e){

    var lastRepeatingGroup = $('.files-uploded-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".student-removes-files-upload", function(e){

   var total = $('.student-removes-files-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});


$(document).on("click", "#adds_file_uploads", function(e){

    var lastRepeatingGroup = $('.student_upload_files_div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 
$(document).on("click", ".files-uploads", function(e){

   var total = $('.files-uploads').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});


$(document).on("click", "#add_file_upload", function(e){

    var lastRepeatingGroup = $('.student-file-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 


$(document).on("click", ".removes-files", function(e){

   var total = $('.removes-files').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});
