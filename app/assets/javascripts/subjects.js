/* comm */
$(document).on("click", ".edit-subject", function(e){
// alert("abc");
        var myID =$(this).attr('id');
     //    alert(myID);

       var splString = myID.split("-");
     //  alert(splString);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/subjects/"+splString[1]+"/edit/";
    //    alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $("#editSubjectDivID").dialog({
                    modal: true,
                    minHeight: 300,
                    title: "Edit Subject",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
// Delete

          $(document).on("click", ".delete-subject", function(e){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
              //  alert(splString);
                var retVal = confirm("Are you sure to delete data?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/subjects/delete/"+splString[1];

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



//   $(document).on("click", ".show_class", function(e){
//         var studentCategoryID =$(this).attr('id');
//          alert(studentCategoryID);
//         //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
//         var urlLink = "/subjects/"+studentCategoryID;
//         alert(urlLink);
//         $.ajax({
//             url: urlLink ,
//             cache: false,
//             success: function(html){
//                   $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
//                     modal: true,
//                     title: "Edit Student Category",
//                     open: function () {
                        
//                         $(this).html(html);
//                     }
//                 }); 
               
//             }
//         });
// });

    $(document).on("click", ".create_cls", function(e){
        var urlLink = "/subjects/new/";
      //  alert(urlLink);
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

$(document).on("click", ".add-subject-to-batch", function(e){
        var myID =$(this).attr('id');
        var splString = myID.split("-");
       //  alert(splString);
        //var urlLink = "/student_categories/"+MyId+"/edit";
        var urlLink = "/subjects/select_subject/"+splString[1];
        // alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
             console.log(html);
            //$(this).removeClass("header");
            // $("#manageStudentCategoryID").empty();
            // $("#manageStudentCategoryID").append(html);
          }

        });
});



$(document).on("click", ".select_emp_class", function(e){
 // alert("in side emp ");
        var myID =$(this).attr('id');
        // var splString = myID.split("-");
     //    alert(myID);
        //var urlLink = "/student_categories/"+MyId+"/edit";
        var urlLink = "/subjects/select_subject_emp/"+myID;
        // alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
             console.log(html);
            //$(this).removeClass("header");
            // $("#manageStudentCategoryID").empty();
            // $("#manageStudentCategoryID").append(html);
          }

        });
});


